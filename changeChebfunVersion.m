function changeChebfunVersion(varargin)

switch computer
    case 'MACI64'
        genFolderPath = '/Users/davidagross/Dropbox/matlab/chebfun/';
    case 'PCWIN64'
        genFolderPath = 'T:\My Dropbox\matlab\chebfun\';
        if ~exist(genFolderPath,'dir')
            genFolderPath = 'C:\Dropbox\matlab\chebfun\';
        end
    otherwise
        warning('MATLAB:changeChebfunVersion:unknwncmptr', ...
            'Cannot add path for this system');
end

chebPrefix = 'chebfun_v';
defaultVersion = '4.2.2194';

if nargin < 1 || (nargin == 1 && isempty(varargin{1}))
    files = flipud(dir([genFolderPath chebPrefix '*']));
    F = numel(files);
    fmt = ['%' sprintf('%i',ceil(log10(F))) 'i'];
    for f = F:-1:1
        fprintf(1,[fmt ' - %s\n'],f,files(f).name);
    end
    fprintf(1,[fmt ' - %s\n'],0,'grab the nightly build');
    answer = input('Desired chebfun version number: ');
    if answer >= 1
        folderName = files(answer).name;
    elseif answer == 0
        folderName = [chebPrefix ...
            grabNightlyChebfunBuild('savePath',genFolderPath)];
    else
        return
    end
else
    if nargin == 1
        chebfunVersion = varargin{1};
    elseif ~ismember('chebfunVersion',varargin(1:2:end))
        chebfunVersion = defaultVersion;
    elseif mod(nargin,2)
        error('MATLAB:startup:varargin', ...
            'Must specify an even number of varargs');
    elseif ismember('chebfunVersion',varargin(1:2:end))
        [~,loc] = ismember('chebfunVersion',varargin(1:2:end));
        chebfunVersion = varargin{2*loc};
    else
        warning('MATLAB:startup:inputargs', ...
            'Unknown number of input arguments');
        keyboard
    end
    
    if isnumeric(chebfunVersion)
        chebfunVersion = sprintf('%g',chebfunVersion);
    end
    if ~ischar(chebfunVersion)
        error('MATLAB:changeChebfunVersion:numeric', ...
            'chebfunVersion must be numeric or char array');
    end
    folderName = [chebPrefix regexprep(chebfunVersion,'\.','_')];    
end

chebfunPath = [genFolderPath folderName];

[~,~,~,~,~,~,splits]= regexp(path,pathsep);
hasChebfunStr = @(i)~isempty(regexp(i,'chebfun','once'));
hasChebfunVec = cell2mat(cellfun(hasChebfunStr,splits,'UniformOutput',0));
if sum(hasChebfunVec)
    if sum(hasChebfunVec) > 1, pluralStr = 's'; else pluralStr = ''; end
    fprintf(1,['Remove from path %i old chebfun path' pluralStr '\n'], ...
        sum(hasChebfunVec));
    rmpath(splits{hasChebfunVec})
end
fprintf(1,'Adding to path: %s\n',chebfunPath);
addpath(chebfunPath)

end