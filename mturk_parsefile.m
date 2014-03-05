function data = mturk_parsefile(filename)
    % read
    text = mturk_fileread(filename);
    
    data = struct();
    nb_lines = length(text);
    for i_line = 1:nb_lines
        % parse line
        i_colon = find(text{i_line}==':',1,'first');
        
        % field
        field = text{i_line}(1 : i_colon-2);
        
        % value
        structvalue = text{i_line}(i_colon+2 : end);
        
        % parse JSON
        structvalue = mturk_parsejson(structvalue);
        
        % save
        data.(field) = structvalue{1};
    end
end