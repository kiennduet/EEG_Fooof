
function data_pca = pcaFunction(data)

% Preprocess your data as needed (e.g., normalize/standardize)
data_mean = mean(data);
data_std = std(data);
normalized_data = bsxfun(@minus, data, data_mean);
normalized_data = bsxfun(@rdivide, normalized_data, data_std);

% Apply PCA using pca function
[coeff, score, latent, tsquared, explained] = pca(normalized_data);

cumulative_explained = cumsum(explained);

for i = 1 : size(cumulative_explained,1)
    if cumulative_explained(i) >= 98
        num_components_to_keep = i;
        break;
    end
end

pca_components = coeff(:, 1:num_components_to_keep);

% Project your data into the PCA space
data_pca = normalized_data * pca_components;
fprintf('Number of Components to Keep: %d \n', num_components_to_keep);

% out = struct('data_pca', data_pca, 'num_components_to_keep', num_components_to_keep);

end