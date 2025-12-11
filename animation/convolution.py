from __future__ import annotations

from manim_imports_ext import *
from supplements import *
import scipy.signal


def get_aligned_pairs(group1, group2, n):
    return VGroup(
        *(VGroup(m1, m2) for m1 in group1 for m2 in group2 if m1.index + m2.index == n)
    )


def get_row_shift(top_row, low_row, n):
    min_index = low_row[0].index
    max_index = top_row[-1].index
    max_sum = min_index + max_index
    if n <= max_sum:
        x_shift = top_row[n - 2 * min_index].get_x() - low_row[0].get_x()
    else:
        x_shift = top_row[-1].get_x() - low_row[n - max_sum].get_x()
    return low_row.animate.shift(x_shift * RIGHT)


def prod(values):
    return reduce(op.mul, values, 1)


def get_lagrange_polynomial(data):
    def poly(x):
        return sum(
            y0
            * prod((x - x1) for x1, y1 in data if x1 != x0)
            / prod((x0 - x1) for x1, y1 in data if x1 != x0)
            for x0, y0 in data
        )

    return poly


class Main(InteractiveScene):
    image_name = "UHHLogo.jpg"
    image_height = 6.0
    kernel_tex = None
    scalar_conv = False
    pixel_stroke_width = 1.0
    pixel_stroke_opacity = 1.0
    kernel_decimal_places = 2
    kernel_color = BLUE
    grayscale = False

    def construct(self):
        self.zoom_to_kernel(run_time=0)
        self.wait(5)
        self.reset_frame()

        stops = (131,)
        final_run_time = 8
        # March
        for index in stops:
            self.set_index(index)
            self.zoom_to_kernel()
            if index == stops[0]:
                top_bar = self.show_pixel_sum(tex=R"\frac{1}{9}")
            self.wait()
            self.zoom_to_new_pixel(run_time=8)
            self.wait()
            if index == stops[0]:
                self.play(FadeOut(top_bar))
            self.reset_frame()

        # Edge detection kernel
        new_kernel = np.array([[-0.5, 0, 0.5], [-1, 0, 1], [-0.5, 0, 0.5]])

        kernel_anims = []
        for square, val in zip(self.kernel_array, new_kernel.flatten()):
            old_mob = square.submobjects[-1]
            new_mob = DecimalNumber(val, num_decimal_places=0)
            new_mob.match_style(old_mob)
            new_mob.set_width(square.get_width() * 0.7)
            new_mob.move_to(square)
            kernel_anims.append(Transform(old_mob, new_mob))

        self.play(*kernel_anims)

        pixels = self.get_pixel_value_array() / 255.0
        if self.scalar_conv:
            conv = scipy.signal.convolve(pixels.mean(2), new_kernel, mode="same")
        else:
            conv = scipy.signal.convolve(
                pixels, np.expand_dims(new_kernel, 2), mode="same"
            )

        conv = np.clip(conv, -1, 1)

        new_conv_array = self.get_pixel_array(conv)
        self.play(
            *(
                square.animate.set_fill(new_square.get_fill_color())
                for square, new_square in zip(self.conv_array, new_conv_array)
            )
        )

        self.set_index(len(self.pixel_array) - 1, run_time=final_run_time)
        self.wait()

    def setup(self):
        super().setup()
        # Set up the pixel grids
        pixels = self.get_pixel_value_array() / 255.0
        kernel = self.get_kernel()
        if self.scalar_conv:
            conv = scipy.signal.convolve(pixels.mean(2), kernel, mode="same")
        else:
            conv = scipy.signal.convolve(pixels, np.expand_dims(kernel, 2), mode="same")

        conv = np.clip(conv, -1, 1)

        pixel_array = self.get_pixel_array(pixels)
        kernel_array = self.get_kernel_array(kernel, pixel_array, tex=self.kernel_tex)
        conv_array = self.get_pixel_array(conv)
        conv_array.set_fill(opacity=0)

        VGroup(pixel_array, conv_array).arrange(RIGHT, buff=2.0)
        kernel_array.move_to(pixel_array[0])

        self.add(pixel_array)
        self.add(conv_array)
        self.add(kernel_array)

        # Set up index tracker
        index_tracker = ValueTracker(0)

        def get_index():
            return int(clip(index_tracker.get_value(), 0, len(pixel_array) - 1))

        kernel_array.add_updater(lambda m: m.move_to(pixel_array[get_index()]))
        conv_array.add_updater(lambda m: m.set_fill(opacity=0))
        conv_array.add_updater(lambda m: m[: get_index() + 1].set_fill(opacity=1))

        right_rect = conv_array[0].copy()
        right_rect.set_fill(opacity=0)
        right_rect.set_stroke(self.kernel_color, 4, opacity=1)
        right_rect.add_updater(lambda m: m.move_to(conv_array[get_index()]))
        self.add(right_rect)

        self.index_tracker = index_tracker
        self.pixel_array = pixel_array
        self.kernel_array = kernel_array
        self.conv_array = conv_array
        self.right_rect = right_rect

    def get_pixel_value_array(self):
        im_path = get_full_raster_image_path(self.image_name)
        image = Image.open(im_path)
        return np.array(image)[:, :, :3]

    def get_pixel_array(self, array: np.ndarray):
        height, width = array.shape[:2]

        pixel_array = Square().get_grid(height, width, buff=0)
        for pixel, value in zip(pixel_array, it.chain(*array)):
            if value.size == 3:
                # Value is rgb valued
                rgb = np.abs(value).clip(0, 1)
                if self.grayscale:
                    rgb[:] = rgb.mean()
            else:
                # Treat as scalar, color red for negative green for positive
                rgb = [max(-value, 0), max(value, 0), max(value, 0)]
            pixel.set_fill(rgb_to_color(rgb), 1.0)
        pixel_array.set_height(self.image_height)
        pixel_array.set_max_width(5.75)
        pixel_array.set_stroke(
            WHITE, self.pixel_stroke_width, self.pixel_stroke_opacity
        )

        return pixel_array

    def get_kernel_array(self, kernel: np.ndarray, pixel_array: VGroup, tex=None):
        kernel_array = VGroup()
        values = VGroup()
        for row in kernel:
            for x in row:
                square = pixel_array[0].copy()
                square.set_fill(BLACK, 0)
                square.set_stroke(self.kernel_color, 2, opacity=1)
                if tex:
                    value = OldTex(tex)
                else:
                    value = DecimalNumber(
                        x, num_decimal_places=self.kernel_decimal_places
                    )
                value.set_width(square.get_width() * 0.7)
                value.set_backstroke(BLACK, 3)
                value.move_to(square)
                values.add(value)
                square.add(value)
                kernel_array.add(square)
        for value in values:
            value.set_height(values[0].get_height())
        kernel_array.reverse_submobjects()
        kernel_array.arrange_in_grid(*kernel.shape, buff=0)
        kernel_array.move_to(pixel_array[0])
        return kernel_array

    def get_kernel(self):
        return np.ones((3, 3)) / 9

    # Setup combing and zooming
    def set_index(self, value, run_time=8, rate_func=linear):
        self.play(
            self.index_tracker.animate.set_value(value),
            run_time=run_time,
            rate_func=rate_func,
        )

    def zoom_to_kernel(self, run_time=2):
        ka = self.kernel_array
        self.play(
            self.camera.frame.animate.set_height(1.5 * ka.get_height()).move_to(ka),
            run_time=run_time,
        )

    def zoom_to_new_pixel(self, run_time=4):
        ka = self.kernel_array
        ca = self.conv_array
        frame = self.camera.frame
        curr_center = frame.get_center().copy()
        index = int(self.index_tracker.get_value())
        new_center = ca[index].get_center()
        center_func = bezier([curr_center, curr_center, new_center, new_center])

        target_height = 1.5 * ka.get_height()
        height_func = bezier(
            [
                frame.get_height(),
                frame.get_height(),
                FRAME_HEIGHT,
                target_height,
                target_height,
            ]
        )
        self.play(
            UpdateFromAlphaFunc(
                frame, lambda m, a: m.set_height(height_func(a)).move_to(center_func(a))
            ),
            run_time=run_time,
            rate_func=linear,
        )

    def reset_frame(self, run_time=2):
        self.play(self.camera.frame.animate.to_default_state(), run_time=run_time)

    def show_pixel_sum(self, tex=None, convert_to_vect=True, row_len=9):
        # Setup sum
        ka = self.kernel_array
        pa = self.pixel_array
        frame = self.camera.frame

        rgb_vects = VGroup()
        lil_pixels = VGroup()
        expr = VGroup()

        ka_copy = VGroup()
        stroke_width = float(2 * FRAME_HEIGHT / frame.get_height())

        lil_height = 1.0
        for square in ka:
            ka_copy.add(square.copy().set_stroke(TEAL, stroke_width))
            sc = square.get_center()
            pixel = pa[np.argmin([get_norm(p.get_center() - sc) for p in pa])]
            color = pixel.get_fill_color()
            rgb = color_to_rgb(color)
            rgb_vect = DecimalMatrix(rgb.reshape((3, 1)), num_decimal_places=2)
            rgb_vect.set_height(lil_height)
            rgb_vect.set_color(color)
            if get_norm(rgb) < 0.1:
                rgb_vect.set_color(WHITE)
            rgb_vects.add(rgb_vect)

            lil_pixel = pixel.copy()
            lil_pixel.match_width(rgb_vect)
            lil_pixel.set_stroke(WHITE, stroke_width)
            lil_pixels.add(lil_pixel)

            if tex:
                lil_coef = OldTex(tex, font_size=36)
            else:
                lil_coef = square[0].copy()
                lil_coef.set_height(lil_height * 0.5)
            expr.add(lil_coef, lil_pixel, OldTex("+", font_size=48))

        expr[-1].scale(0, about_edge=LEFT)  # Stray plus
        rows = VGroup(
            *(expr[n : n + 3 * row_len] for n in range(0, len(expr), 3 * row_len))
        )
        for row in rows:
            row.arrange(RIGHT, buff=0.2)
        rows.arrange(DOWN, buff=0.4, aligned_edge=LEFT)

        expr.set_max_width(FRAME_WIDTH - 1)
        expr.to_edge(UP)
        expr.fix_in_frame()

        for vect, pixel in zip(rgb_vects, lil_pixels):
            vect.move_to(pixel)
            vect.set_max_width(pixel.get_width())
        rgb_vects.fix_in_frame()

        # Reveal top
        top_bar = FullScreenRectangle().set_fill(BLACK, 1)
        top_bar.set_height(rgb_vects.get_height() + 0.5, stretch=True, about_edge=UP)
        top_bar.fix_in_frame()

        self.play(
            frame.animate.scale(1.2, about_edge=DOWN),
            FadeIn(top_bar, 2 * DOWN),
        )

        # Show sum
        for n in range(len(ka_copy)):
            self.remove(*ka_copy)
            self.add(ka_copy[n])
            self.add(expr[: 3 * n + 2])
            self.wait(0.25)
        self.remove(*ka_copy)
        if convert_to_vect:
            self.play(
                LaggedStart(
                    *(
                        Transform(lil_pixel, rgb_vect)
                        for lil_pixel, rgb_vect in zip(lil_pixels, rgb_vects)
                    )
                )
            )
        self.wait()
        result = VGroup(top_bar, expr)
        return result


class BoxBlurMario(Main):
    kernel_tex = "1 / 9"
    image_name = "UHHLogo.jpg"
    pixel_stroke_opacity = 0.5
    stops = (131, 360)
    final_run_time = 8

    def construct(self):
        # March
        for index in self.stops:
            self.set_index(index)
            self.zoom_to_kernel()
            if index == self.stops[0]:
                top_bar = self.show_pixel_sum(tex=R"\frac{1}{9}")
            self.wait()
            self.zoom_to_new_pixel(run_time=8)
            self.wait()
            if index == self.stops[0]:
                self.play(FadeOut(top_bar))
            self.reset_frame()
        self.set_index(len(self.pixel_array) - 1, run_time=self.final_run_time)
        self.wait()


class BoxBlurCat(BoxBlurMario):
    image_name = "PixelArtCat"
    stops = ()
    final_run_time = 20


class GaussianBluMario(Main):
    kernel_decimal_places = 3
    focus_index = 256
    final_run_time = 10

    def construct(self):
        # March!
        self.set_index(self.focus_index)
        self.wait()
        self.zoom_to_kernel()
        self.wait()

        # Gauss surface
        kernel_array = self.kernel_array
        frame = self.camera.frame

        gaussian = ParametricSurface(
            lambda u, v: [u, v, np.exp(-(u**2) - v**2)],
            u_range=(-3, 3),
            v_range=(-3, 3),
            resolution=(101, 101),
        )
        gaussian.set_color(BLUE, 0.8)
        gaussian.match_width(kernel_array)
        gaussian.stretch(2, 2)
        gaussian.add_updater(lambda m: m.move_to(kernel_array, IN))

        self.play(FadeIn(gaussian), frame.animate.reorient(10, 70), run_time=3)
        self.wait()
        top_bar = self.show_pixel_sum(convert_to_vect=False)
        self.wait()
        self.zoom_to_new_pixel()
        self.wait()
        self.play(
            frame.animate.set_height(8).reorient(0, 60).move_to(ORIGIN),
            FadeOut(top_bar, time_span=(0, 1)),
            run_time=3,
        )

        # More walking
        self.set_index(len(self.pixel_array), run_time=self.final_run_time)
        self.wait()

    def get_kernel(self):
        # Oh good, hard coded, I hope you feel happy with yourself.
        return np.array(
            [
                [0.00296902, 0.0133062, 0.0219382, 0.0133062, 0.00296902],
                [0.0133062, 0.0596343, 0.0983203, 0.0596343, 0.0133062],
                [0.0219382, 0.0983203, 0.162103, 0.0983203, 0.0219382],
                [0.0133062, 0.0596343, 0.0983203, 0.0596343, 0.0133062],
                [0.00296902, 0.0133062, 0.0219382, 0.0133062, 0.00296902],
            ]
        )


class GaussianBlurCat(GaussianBluMario):
    image_name = "PixelArtCat"
    focus_index = 254

    def construct(self):
        for arr in self.pixel_array, self.conv_array:
            arr.set_stroke(width=0.5, opacity=0.5)
        super().construct()


class GaussianBlurCatNoPause(GaussianBlurCat):
    stops = ()
    focus_index = 0
    final_run_time = 30


class SobelFilter1(Main):
    scalar_conv = True
    image_name = "BitRandy"
    pixel_stroke_width = 1
    pixel_stroke_opacity = 0.2
    kernel_color = YELLOW
    stops = (194, 400, 801)
    grayscale = True

    def construct(self):
        self.zoom_to_kernel()
        # Show kernel
        kernel = self.kernel_array
        kernel.generate_target()
        for square in kernel.target:
            v = square[0].get_value()
            square.set_fill(
                rgb_to_color([2 * max(-v, 0), 2 * max(v, 0), 2 * max(v, 0)]),
                opacity=0.5,
                recurse=False,
            )
            square.set_stroke(WHITE, 1, recurse=False)
        self.play(MoveToTarget(kernel))
        self.wait()
        self.reset_frame()

        # Example walking
        for index in self.stops:
            self.set_index(index)
            self.zoom_to_kernel()
            self.play(
                *(
                    square.animate.set_fill(opacity=0, recurse=False)
                    for square in kernel
                ),
                rate_func=there_and_back_with_pause,
                run_time=3,
            )
            self.add(kernel)
            self.wait()
            self.zoom_to_new_pixel()
            self.wait()
            self.reset_frame()
        self.set_index(len(self.pixel_array) - 1, run_time=20)

    def get_kernel(self):
        return np.array(
            [
                [-0.25, 0, 0.25],
                [-0.5, 0, 0.5],
                [-0.25, 0, 0.25],
            ]
        )


class SobelFilter2(SobelFilter1):
    stops = ()

    def get_kernel(self):
        return super().get_kernel().T


class SobelFilterCat(SobelFilter1):
    scalar_conv = True
    image_name = "PixelArtCat"
    pixel_stroke_width = 1
    pixel_stroke_opacity = 0.2
    kernel_color = WHITE
    stops = ()
    grayscale = False


class SobelFilterKirby(SobelFilter1):
    image_name = "KirbySmall"
    grayscale = False


class SharpenFilter(Main):
    image_name = "KirbySmall"
    kernel_decimal_places = 1
    grayscale = False

    def construct(self):
        for arr in self.pixel_array, self.conv_array:
            arr.set_stroke(WHITE, 0.25, 0.5)
        for square in self.kernel_array:
            square[0].scale(0.6)
        self.set_index(len(self.pixel_array) - 1, run_time=20)

    def get_kernel(self):
        return np.array(
            [
                [0.0, 0.0, -0.25, 0.0, 0.0],
                [0.0, -0.25, -0.5, -0.25, 0.0],
                [-0.25, -0.5, 5.0, -0.5, -0.25],
                [0.0, -0.25, -0.5, -0.25, 0.0],
                [0.0, 0.0, -0.25, 0.0, 0.0],
            ]
        )
