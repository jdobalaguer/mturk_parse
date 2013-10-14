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
        % foreach cell
        ret.(this_field) = s{1}.(this_field);
        for i_s = 2:nb_s
            ret.(this_field) = mturk_concatstruct(ret.(this_field),s{i_s}.(this_field));
        end
    end
end