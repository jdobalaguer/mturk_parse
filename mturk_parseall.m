function alldata = mturk_parseall(pathname)
    alldata = {};
    
    % dir files
    allfiles = dir(pathname);
    
    % remove directories
    i_allfiles = 1;
    while i_allfiles <= length(allfiles)
        if allfiles(i_allfiles).name(1)=='.'
            allfiles(i_allfiles) = [];
        else
            i_allfiles = i_allfiles+1;
        end
    end
    nb_allfiles = length(allfiles);
    
    % parse files
    for i_allfiles = 1:nb_allfiles
        % name
        filename = [pathname,filesep,allfiles(i_allfiles).name];
        % print it
        fprintf(['file "',filename,'" : %d / %d\n'],i_allfiles,nb_allfiles);
        % read and parse
        data = mturk_parsefile(filename);
        % save
        alldata{i_allfiles} = data;
    end
    
    
    % concatenate
%    alldata = mturk_concatall(alldata);
    
    % uncell
%    alldata{i_allfiles} = mturk_uncell(alldata{i_allfiles});
end