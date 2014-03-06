function ret = mturk_concatstruct(dim,s1,s2)
    
    u_field = fieldnames(s1);
     nb_fields = length(u_field);
    
    ret = struct();
    for i_field = 1:nb_fields
        this_field = u_field{i_field};
        % get values
        v1 = s1.(this_field);
        v2 = s2.(this_field);
        % convert to cell
        if ~strcmp(class(v1),class(v2))
            if ~iscell(v1); v1={v1}; end
            if ~iscell(v2); v2={v2}; end
        end
        % concat values
        v = cat(dim,v1,v2);
        % save value
        ret.(this_field) = v;
    end
end