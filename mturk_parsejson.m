function [data] = mturk_parsejson(json)
% [DATA JSON] = PARSE_JSON(json)
% This function parses a JSON string and returns a cell array with the
% parsed data. JSON objects are converted to structures and JSON arrays are
% converted to cell arrays.
%
% Example:
% google_search = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=matlab';
% matlab_results = parse_json(urlread(google_search));
% disp(matlab_results{1}.responseData.results{1}.titleNoFormatting)
% disp(matlab_results{1}.responseData.results{1}.visibleUrl)

    data = cell(0,1);
    while ~isempty(json)
        data{end+1} = parse_value(); %#ok<AGROW>
    end
    
    %% VALUE
    
    % parse value
    function [value] = parse_value()
        value = [];
        if ~isempty(json)
            json = strtrim(json);

            switch lower(json(1))
                case '"'
                    json(1) = [];
                    value = parse_string();

                case '{'
                    json(1) = [];
                    value = parse_object();

                case '['
                    json(1) = [];
                    value = parse_array();

                case 't'
                    value = true;
                    if (length(json) >= 4)
                        json(1:4) = [];
                    else
                        ME = MException('json:parse_value',['Invalid TRUE identifier: ' id json]);
                        ME.throw;
                    end

                case 'f'
                    value = false;
                    if (length(json) >= 5)
                        json(1:5) = [];
                    else
                        ME = MException('json:parse_value',['Invalid FALSE identifier: ' id json]);
                        ME.throw;
                    end

                case 'n'
                    value = nan;
                    if (length(json) >= 4) && strcmp(json(1:4),'ull')
                        json(1:3) = [];
                    elseif (length(json) >= 3) && strcmp(json(1:3),'an')
                        json(1:2) = [];
                    else
                        ME = MException('json:parse_value',['Invalid NULL identifier: ' id json]);
                        ME.throw;
                    end

                otherwise
                    value = parse_number(); % Need to put the id back on the string
            end
        end
    end

    %% ARRAY
    
    % parse array
    function [data] = parse_array()
        data = cell(0,1);
        while ~isempty(json)
            if strcmp(json(1),']') % Check if the array is closed
                json(1) = [];
                return
            end

            value = parse_value();

            if isempty(value)
                ME = MException('json:parse_array',['Parsed an empty value: ' json]);
                ME.throw;
            end
            data{end+1} = value; %#ok<AGROW>

            while ~isempty(json) && ~isempty(regexp(json(1),'[\s,]','once'))
                json(1) = [];
            end
        end
    end

    %% OBJECT
    
    % parse object
    function [data] = parse_object()
        data = [];
        while ~isempty(json)
            id = json(1);
            json(1) = [];

            switch id
                case '"' % Start a name/value pair
                    [name,value] = parse_name_value();
                    if isempty(name)
                        ME = MException('json:parse_object',['Can not have an empty name: ' json]);
                        ME.throw;
                    end
                    data.(name) = value;

                case '}' % End of object, so exit the function
                    return

                otherwise % Ignore other characters
            end
        end
    end

    % parse name value
    function [name,value] = parse_name_value()
        name = [];
        value = [];
        if ~isempty(json)
            [name] = parse_string();

            % Skip spaces and the : separator
            while ~isempty(json) && ~isempty(regexp(json(1),'[\s:]','once'))
                json(1) = [];
            end
            value = parse_value();
        end
    end

    %% STRING
    
    % parse string
    function [string] = parse_string()
        string = [];
        while ~isempty(json)
            letter = json(1);
            json(1) = [];

            switch lower(letter)
                case '\' % Deal with escaped characters
                    if ~isempty(json)
                        code = json(1);
                        json(1) = [];
                        switch lower(code)
                            case '"'
                                new_char = '"';
                            case '\'
                                new_char = '\';
                            case '/'
                                new_char = '/';
                            case {'b' 'f' 'n' 'r' 't'}
                                new_char = sprintf('\%c',code);
                            case 'u'
                                if length(json) >= 4
                                    new_char = sprintf('\\u%s',json(1:4));
                                    json(1:4) = [];
                                end
                            otherwise
                                new_char = [];
                        end
                    end

                case '"' % Done with the string
                    return

                otherwise
                    new_char = letter;
            end
            % Append the new character
            string = [string new_char]; %#ok<AGROW>
        end
    end

    %% NUMBER
    
    % parse number
    function [num] = parse_number()
        num = [];
        if ~isempty(json)
            % Validate the floating point number using a regular expression
            [s,e] = regexp(json,'^[\w]?[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?[\w]?','once');
            if ~isempty(s)
                num_str = json(s:e);
                json(s:e) = [];
                num = str2double(strtrim(num_str));
            end
        end
    end

end