function result = containsStrings(container,strings,exclusions)

    for i = 1:length(strings)
        
        if contains(container,strings{i})
            
            if ~isempty(exclusions)
                
                for j = 1:length(exclusions)
                    if contains(container,exclusions{j})
                        result = false;
                        return
                    end
                end
                
            end
            
            result = true;
            return
                
        end
        
    end
    
    result = false;
    
end

