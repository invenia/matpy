% A way to interact with python from matlab.
% 
% Inputs:
% 	1) the type of command, which can be any of the following:
% 		a. 'eval' this will run the second parameter as python
% 		b. 'set'  this will export the second parameter to python
% 		c. 'get'  this will import the second parameter from python by name
% 		d. 'debugon'  used for debugging
% 		c. 'debugoff' used for debugging (default is this)
% 	2) this parameter will interact with python depending on what is passed in 
% 		the first parameter, see above for what that would be
% 
% Output:
% 	only for 'get' command, will return the value stored in python
% 
% Examples:
% 	py('eval', 'print "hello, world"')
%	py('eval', 'print 2+2')
%	py('set', 'name_of_var', var)
%	var = py('get' 'name_of_var')

function varargout = py(varargin)
	
	lastWorkingDir = pwd;
	cd(mfiledir);

	home = getenv('HOME');
	partialPath = getParsedPypath();
	parent ='/..';

	CHAR16_T = '-Dchar16_t=uint16_T';

	pre = '-I';
	includePath = '/include/python2.7';
	PYINCLUDEDIR = strcat(pre, home, partialPath, parent, includePath)

	pre = '-L';
	libraryPath = '/lib/python2.7';
	PYLIBPATH = strcat(pre, home, partialPath, parent, libraryPath)

	pre = '''-DPYPATH=\"';
	pythonPath = '/python';
	post = '\"''';
	PYPATH = strcat(pre, home, partialPath, pythonPath, post);

	SPACE = ' ';
	CFLAG = 'CFLAGS="\$CFLAGS';
	PYNAME = '-lpython2.7';
	END_QUOTATION = '"';
	PRE = [CFLAG, SPACE, PYNAME, SPACE, PYPATH, END_QUOTATION];

	try
		mex('py.cpp', PRE, CHAR16_T, PYINCLUDEDIR, PYLIBPATH);
	catch e
		cd(lastWorkingDir);
		rethrow(e);
	end

	cd(lastWorkingDir);
	
	[varargout{1:nargout}] = py(varargin{:});
end

function partialPath = getParsedPypath()
	temp = getPypath();
	tokens = splitBySlash(temp);
	partialPath = cutOffEndsAndMerge(tokens);
end

function partialPath = getPypath()

	SUCCESS = 0;
	[success, partialPath] = system('cat ~/.matpyrc');

	if success ~= SUCCESS
		%Failed to find custom python, using systems

		[success, partialPath] = system('which python');

		if success ~= SUCCESS
			error('Python could not be found');
		end
	end

end

function tokens = splitBySlash(str)
	tokens = strread(str, '%s', 'delimiter', '/')
end

function partialPath = cutOffEndsAndMerge(tokens)
	partialPath = sprintf('/%s' ,tokens{2:end-1})
end