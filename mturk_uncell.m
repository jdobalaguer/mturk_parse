function ret = mturk_uncell(c)
    %% is a struct
    if isstruct(c)
        ret = struct();
        u_field = fieldnames(c);
        nb_fields = length(u_field);
        for i_field = 1:nb_fields
            this_field = u_field{i_field};
            ret.(this_field) = mturk_uncell(c.(this_field));
        end
        return;
    end
    
    %% is not a cell
    if ~iscell(c)
        ret = c;
        return
    end
        
    nb_cells = length(c);
    %% empty
    if ~nb_cells
        ret = [];
        return;
    end
    
    %% includes a string
    if ischar(c{1})
        ret = c;
        return;
    end
    
    %% includes another cell
    if iscell(c{1})
        for i_cell = 1:nb_cells
            c{i_cell} = mturk_uncell(c{i_cell});
        end
    end    
    % includes a number
    if isnumeric(c{1})
        ret = cell2mat(c);
        ret = reshape(ret,[nb_cells,size(c{1})]);
        return;
    end
    
    
    %% else
    ret = c;
end