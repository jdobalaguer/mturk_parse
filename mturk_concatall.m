function ret = mturk_concatall(s)
    u_field = fieldnames(s{1});
    nb_fields = length(u_field);
    nb_s = length(s);
    
    ret = struct();
    if ~nb_s
        return
    end
    
    % foreach field
    for i_field = 1:nb_fields
        this_field = u_field{i_field};
        % set cat dimension
        switch this_field
            case 'sdata'
                catdim = 1;
            case 'edata'
                catdim = 2;
            case 'parameters'
                catdim = 2;
            case 'numbers'
                catdim = 2;
            otherwise
                fprintf('mturk_concatall: WARNING. unknown field %s.   \n');
                fprintf('mturk_concatall: WARNING. default cat dim = 2.\n');
                catdim = 2;
        end
        
        % foreach cell
        ret.(this_field) = s{1}.(this_field);
        for i_s = 2:nb_s
            ret.(this_field) = mturk_concatstruct(catdim,ret.(this_field),s{i_s}.(this_field));
        end
    end
end