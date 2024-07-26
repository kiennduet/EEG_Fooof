
function rgb = hex2rgb(hexColor)
    hexColor = hexColor(2:end); % Remove '#' character
    rgb = reshape(sscanf(hexColor, '%2x'), 1, 3) / 255;
end