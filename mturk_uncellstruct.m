function [s] = mturk_uncellstruct(s)
    u_field = fieldnames(s);
    nb_fields = length(u_field);
    
    for i_field = 1:nb_fields
        this_field = u_field{i_field};
        s.(this_field) = mturk_uncellcell(s.(this_field));
    end
end