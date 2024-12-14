pkg load image
clear;
input_image = imread("input.jpg");
input_image_grayscale = rgb2gray(input_image);
input_image_threshold = graythresh(input_image_grayscale, "MinError");
input_image_black_white = ~im2bw(input_image_grayscale, input_image_threshold);
regions = bwlabel(input_image_black_white);
properts = regionprops(regions, "all");
final_image = input_image;
for j = 1:numel(properts)
    if(properts(j).Area == 1)
        continue;
    endif
    if((properts(j).FilledArea / (properts(j).BoundingBox(:, 3) * properts(j).BoundingBox(:, 4))) < 0.95)
        filled_image_property = properts(j).FilledImage;
        image_property_regions = bwlabel(filled_image_property);
        image_property_properts = regionprops(image_property_regions, 'all');
        if(numel(image_property_properts) != 1)
            continue;
        endif
        bw_rotated_image = imrotate(filled_image_property, -image_property_properts(1).Orientation, 'linear');
        bw_rotated_image_regions = bwlabel(bw_rotated_image);
        bw_rotated_image_properts = regionprops(bw_rotated_image_regions, 'all');
        if(numel(bw_rotated_image_properts) != 1 || (bw_rotated_image_properts(1).FilledArea / (bw_rotated_image_properts(1).BoundingBox(:, 3) * bw_rotated_image_properts(1).BoundingBox(:, 4))) < 0.95)
            continue;
        endif
    endif
    property_buffer = properts(j);
    for i = 1:numel(property_buffer)
        y = round(property_buffer(i).BoundingBox(:, 1));
        x = round(property_buffer(i).BoundingBox(:, 2));
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
imwrite(final_image, "output.png");
imshow(final_image);

