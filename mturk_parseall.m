function alldata = mturk_parseall(pathname)
    
    %% directories
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
    
    %% individual data
    alldata = {};
    
    % parse files
    for i_allfiles = 1:nb_allfiles
        % name
        filename = [pathname,filesep,allfiles(i_allfiles).name];
        if exist([filename,'.mat'],'file')
            % skip
            fprintf(['mturk_parseall: file "%s" : %d / %d (skip)\n'],filename,i_allfiles,nb_allfiles);
            load([filename,'.mat'],'data');
            alldata{end+1} = data;
        else
            try
                % print it
                fprintf(['mturk_parseall: file "%s" : %d / %d\n'],filename,i_allfiles,nb_allfiles);
                % read and parse
                data = mturk_parsefile(filename);
                % save
                save([filename,'.mat'],'data');
                alldata{end+1} = data;
            catch
                fprintf('mturk_parseall: warning. "%s" not parsed',allfiles(i_allfiles).name);
            end
        end
    end
    
    %% alldata
    % concatenate
    alldata = mturk_concatall(alldata);
    % uncell
    alldata{i_allfiles} = mturk_uncell(alldata{i_allfiles});
    % save
    save([pathname,filesep,'alldata.mat'],'alldata');
    
end