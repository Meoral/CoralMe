classdef GraphCutMergeTool < AbstractSegmentationTool
    %GRAPHCUTMERGETOOL A tool that uses user-defined lines to merge 
    % segmented regions.
    properties (Access = private)
    end
    
    
    methods (Access = public)
        % Constructor
        function this = GraphCutMergeTool(segMap)
            if nargin < 1 || isempty(segMap) || isempty(segMap.getMap())
                error('A valid segmentation map must be specified.');
            end            
            this.segMap = segMap;
        end
        
        % Merge all regions that overlap these two points.
        function merge(this, startX, startY, endX, endY)
            map = this.segMap.getMap();
            line = this.coordsToLine(startX, startY, endX, endY);
            
            ids = unique(map(line));
            if numel(ids) > 1
                for i=2:numel(ids)
                   map(map ==ids(i)) = ids(1); 
                end
                this.segMap.setMap(map); % update merged map;
            end
        end
        
        function cut(this, startX, startY, endX, endY)
            % find the region most overlapping with the specified cut
            map = int32(this.segMap.getMap()); % cast needed to work with negative flags
            [line] = this.coordsToLine(startX, startY, endX, endY);
            targetId = mode(map(line));
            newId = max(map(:)) + 1;
            
            % split along line (set to -1)
            cutIds = line(map(line) == targetId);
            map(cutIds) = -1;
            
            % isolate and separate both regions with the cut
            [newLabels,n] = bwlabel(map == targetId,4);
            
            % apply new ids
            map(cutIds) = targetId;
            for i = 2:n
                map(newLabels == i) = newId;
                newId = newId +  1;
            end
            
            % update map
            this.segMap.setMap(map);
        end
     
    end
    
    methods (Access = private)
        function line = coordsToLine(this, startX, startY, endX, endY)
            map = this.segMap.getMap();
            startX = this.toAbsolute(startX, size(map,1));
            endX = this.toAbsolute(endX, size(map,1));
            startY = this.toAbsolute(startY, size(map,2));
            endY = this.toAbsolute(endY, size(map,2));
            
            % snap to edges if close
            t = .02 * size(map,1); % pixel threshold
            startX = this.snapToSides(startX, t, size(map,1));
            endX = this.snapToSides(endX, t, size(map,1));
            startY = this.snapToSides(startY, t, size(map,2));
            endY = this.snapToSides(endY, t, size(map,2));
            
            steps = max(abs(endY - startY),abs(endX - startX));
            X = round(((endX-startX)/steps) * (-1:steps) + startX);
            Y = round(((endY-startY)/steps) * (-1:steps) + startY);
            filter = (X > 0 & X <= size(map,1)) & (Y > 0 & Y <= size(map,2));
            X = X(filter); Y = Y(filter);
            line = sub2ind(size(map), X, Y);
        end        
        
        function y = snapToSides(this, x, t, lim)
            if x < t
                y = 1;
            elseif x > lim - t
                y = lim;
            else
                y = x;
            end
        end
    end
end
