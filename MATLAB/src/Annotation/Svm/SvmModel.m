classdef SvmModel < handle
    % handles an SVM models
    
    properties (Access = public)
        model % LIBSVM's struct
    end
    
    methods (Access = public)
        function this = SvmModel()
        end
        
        % builds a model using the specified features
        function model = train(features, labels)
            classLabels = unique(labels);
            % normalize data
            features(isnan(features)) = 0; % eliminate any possible extraction errors.
            [ features, ~, this.model.normalizer ] = normalize( 'minmax', features);
            
            data.features = features;
            data.labels = labels;
            
            % get weights
            w = getSVMssfactor(data, 2000, classLabels); % a few samples per class is quite enough for training
            data = subsampleDataStruct(data, w);
            
            this.model.svm = trainSimpleSVM(iTrain, w, numel(classLabels));
        end
        
        % tests the specified data on the model (must call train first)
        function probabilities = test(features)
            [ features, ~, ~ ] = normalize( 'minmax', features, [], this.model.normalizer);
            
            [~, ~, probEstimates] = svmpredict(zeros(size(features,1),1), features, this.model.svm, '-b 1');
            
            removedClasses = true(models.(f{1}).SVM.nr_class,1);
            removedClasses(models.(f{1}).SVM.Label) = false;
            [~,reOrderIds] = sort([models.(f{1}).SVM.Label',find(removedClasses)']);
            probabilities = probEstimates(:,reOrderIds);
        end
        
    end
    
end