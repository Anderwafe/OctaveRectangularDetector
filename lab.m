pkg load image
clear;

input_image = imread("input.jpg");
input_image_grayscale = rgb2gray(input_image);
input_image_grayscale_histogram = imhist(input_image_grayscale);
##input_image_threshold = otsuthresh(input_image_grayscale_histogram);
##top0 MinError
##top1 MaxLikelihood/mean
##top2 concavity
input_image_threshold = graythresh(input_image_grayscale, "MinError");
input_image_black_white = ~im2bw(input_image_grayscale, input_image_threshold);
##input_image_black_white_filled = imfill(input_image_black_white, "holes");
##regions = bwlabel(input_image_black_white_filled);
####regions = bwpropfilt(input_image_black_white, 'Extent', [0.6 0.9]);
##properts = regionprops(regions, "all");
####properts = regionprops(filtered_poperts, "all");
##
##final_image = input_image;
##
##for i = 1:numel(properts)
##    y = round(properts(i).BoundingBox(:, 1));
##    x = round(properts(i).BoundingBox(:, 2));
##    h = round(properts(i).BoundingBox(:, 3));
##    w = round(properts(i).BoundingBox(:, 4));
##    for yi = y:y+h
##        final_image(x, yi, 1) = 255;
##        final_image(x, yi, 2) = 0;
##        final_image(x, yi, 3) = 0;
##        final_image(x+w, yi, 1) = 255;
##        final_image(x+w, yi, 2) = 0;
##        final_image(x+w, yi, 3) = 0;
##    endfor
##    for xi = x:x+w
##        final_image(xi, y, 1) = 255;
##        final_image(xi, y, 2) = 0;
##        final_image(xi, y, 3) = 0;
##        final_image(xi, y+h, 1) = 255;
##        final_image(xi, y+h, 2) = 0;
##        final_image(xi, y+h, 3) = 0;
##    endfor
##endfor
##
##subplot(1,2,1);
##imshow(final_image);
##subplot(1,2,2);
##imshow(input_image_black_white);

regions = bwlabel(input_image_black_white);
properts = regionprops(regions, "all");

subplot(1, 2, 1);
imshow(input_image);

final_image = input_image;

for j = 1:numel(properts)
    filled_image_property = properts(j).FilledImage;
    subplot(1,2,2);
    imshow(filled_image_property);
    region_buffer = bwpropfilt(filled_image_property, 'Extent', [0.9 1]);
    property_buffer = regionprops(region_buffer, "all");
    for i = 1:numel(property_buffer)
        y = round(property_buffer(i).BoundingBox(:, 1) + properts(j).BoundingBox(:, 1));
        x = round(property_buffer(i).BoundingBox(:, 2) + properts(j).BoundingBox(:, 2));
        h = round(property_buffer(i).BoundingBox(:, 3));
        w = round(property_buffer(i).BoundingBox(:, 4));
        for yi = y:y+h
            final_image(x, yi, 1) = 255;
            final_image(x, yi, 2) = 0;
            final_image(x, yi, 3) = 0;
            final_image(x+w, yi, 1) = 255;
            final_image(x+w, yi, 2) = 0;
            final_image(x+w, yi, 3) = 0;
        endfor
        for xi = x:x+w
            final_image(xi, y, 1) = 255;
            final_image(xi, y, 2) = 0;
            final_image(xi, y, 3) = 0;
            final_image(xi, y+h, 1) = 255;
            final_image(xi, y+h, 2) = 0;
            final_image(xi, y+h, 3) = 0;
        endfor
    endfor
endfor

imshow(final_image);
