function mturk_parseall(pathname)
    
    %% directories
    pathname = '140304';
    % dir files
    allfiles = dir([pathname,filesep,'*.txt']);
    
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
    
    %% parse data
    for i_allfiles = 1:nb_allfiles
        filename = [pathname,filesep,allfiles(i_allfiles).name];
        % SKIP
        if exist([filename,'.parse.mat'],'file')
            % print it
            fprintf('mturk_parseall: PARSE  file "%s" : %03i / %03i (skip) \n',filename,i_allfiles,nb_allfiles);
        % PARSE
        else
            try
                % print it
                fprintf('mturk_parseall: PARSE  file "%s" : %03i / %03i \n',filename,i_allfiles,nb_allfiles);
                % read and parse
                data = struct();
                data = mturk_parsefile(filename);
                % save
                save([filename,'parse.mat'],'data');
            catch
                % ERROR
                % print
                fprintf('mturk_parseall: WARNING. error while parsing "%s"\n',allfiles(i_allfiles).name);
                % mkdir
                if ~exist([pathname,'_error'],'dir'); mkdir([pathname,'_error']); end
                % move file
                movefile(filename,[pathname,'_error',filesep,allfiles(i_allfiles).name]);
            end
        end
    end
    fprintf('mturk_parseall: \n');
    
    %% uncell data
    for i_allfiles = 1:nb_allfiles
        filename = [pathname,filesep,allfiles(i_allfiles).name];
        % SKIP
        if exist([filename,'.uncell.mat'],'file')
            % print it
            fprintf('mturk_parseall: UNCELL file "%s" : %03i / %03i (skip)\n',filename,i_allfiles,nb_allfiles);
        elseif ~exist([filename,'.parse.mat'],'file')
            % print it
            fprintf('mturk_parseall: UNCELL file "%s" : %03i / %03i (not parsed)\n',filename,i_allfiles,nb_allfiles);
        % UNCELL
        else
            try
                % print it
                fprintf('mturk_parseall: UNCELL file "%s" : %03i / %03i \n',filename,i_allfiles,nb_allfiles);
                % load
                data = struct();
                load([filename,'.parse.mat'],'data');
                % read and parse
                data = mturk_uncell(data);
                % save
                save([filename,'.uncell.mat'],'data');
            catch
                fprintf('mturk_parseall: WARNING. error while uncelling "%s" \n',allfiles(i_allfiles).name);
            end
        end
    end
    fprintf('mturk_parseall: \n');
    
    %% concatenate data
    % print
    fprintf('mturk_parseall: CONCAT all uncelled files\n');
    
    % load
    alldata = {};
    for i_allfiles = 1:nb_allfiles
        filename = [pathname,filesep,allfiles(i_allfiles).name];
        % skip
        if ~exist([filename,'.uncell.mat'],'file')
            % print it
            fprintf('mturk_parseall: file "%s" : %03i / %03i (not uncelled)\n',filename,i_allfiles,nb_allfiles);
        % load
        else
            data = struct();
            load([filename,'.uncell.mat'],'data');
            alldata{end+1} = data;
        end        
    end
    
    % concatenate
    alldata = mturk_concatall(alldata);
    
    % save
    save([pathname,filesep,'alldata.mat'],'alldata');

    % print
    fprintf('mturk_parseall: \n');
    
end