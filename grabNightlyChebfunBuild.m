function chebfunVersion = grabNightlyChebfunBuild(varargin)

url = 'http://www2.maths.ox.ac.uk/chebfun/nightly/';
savePath = '/Users/davidagross/Dropbox/matlab/chebfun';

[tf,loc] = ismember('savePath',varargin);
if tf
    savePath = varargin{loc+1};
end
    

disp('Reading nightly build information...');
str = urlread(url);
ret = regexpi(str,'<a[^>]*>(?<link>chebfun_v.*?)</a>','names');
if numel(ret) > 1
    keyboard
end
fname = [savePath ret(1).link];
dateTag = datestr(now,'_mmDD');
chebfunVersion = [regexprep(ret(1).link(10:end-4),'\.','_') dateTag];
outDir = [savePath 'chebfun_v' chebfunVersion];
if ~exist(outDir,'dir')
    disp('Downloading...');
    urlwrite([url ret(1).link],fname);
    disp('Unzipping...');
    unzip(fname,savePath);
    disp('Relocating Dir...');
    movefile([savePath 'chebfun'],outDir);
    disp('Relocating Zip...');
    movefile(fname,[outDir '/' ret(1).link]);
else
    disp('Already have it...'); 
end

end