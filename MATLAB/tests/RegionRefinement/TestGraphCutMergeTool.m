%% CONSTRUCTOR
fprintf('Creating GraphCutMergeTool with no arguments... ');
error = false;
try
    a = GraphCutMergeTool([]);
    error = true; % should fail!
catch
end
if error
    fprintf('FAILED\n');
else
    fprintf('PASSED\n');
end

%%
fprintf('Creating GraphCutMergeTool... ');
try
    %create a mock setgmentation map
    f = [ones(100)*1,ones(100)*2];
    map = SegmentationMap();
    map.setMap(f);
    % create GraphCutMergeTool 
    a = GraphCutMergeTool(map);
    fprintf('PASSED\n');
catch 
    fprintf('FAILED\n');
end

%% Merging nothing
fprintf('Calling merge... ');
try
    a.merge(1, 1, 2, 2);
    fprintf('PASSED\n');
catch 
    fprintf('FAILED\n');
end

%% Merging two regions
fprintf('Merge two parts... ');

a.merge(0,0,.99,.99);
if numel(unique(map.getMap())) == 1    
    fprintf('PASSED\n');
else
    fprintf('FAILED\n');
end


%% Cutting two regions
fprintf('Cutting region into two smaller regions... ');
f = imread('ids.bmp');
map.setMap(f);    
a.cut(0,0,.99,.99);
if numel(unique(map.getMap())) == 3    
    fprintf('PASSED\n');
else
    fprintf('FAILED\n');
end

