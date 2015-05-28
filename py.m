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
	SPACE = ' '

	CHAR16_t = '-Dchar16_t=uint16_T';

	PYNAME = '-lpython2.7';

	pre = '-I';
	partialPath = '/.pyenv/versions/2.7.9/include/python2.7';
	PYINCLUDEDIR = strcat(pre, home, partialPath);

	pre = '-L';
	partialPath = '/.pyenv/versions/2.7.9/lib/python2.7';
	PYLIBPATH = strcat(pre, home, partialPath);

	pre = '''-DPYPATH=\"';
	post = '\"''';
	partialPath = '/.pyenv/versions/2.7.9/bin/python';
	PYPATH = strcat(pre, home, partialPath, post);

	% I could not include PYNAME here without the compiler throwing a strange error.
	MODIFIERS = [CHAR16_t, SPACE, PYPATH, SPACE, PYINCLUDEDIR, SPACE, PYLIBPATH];

	try
		% I could not place PYPATH here without compining it with other strings 
		% without the compiler ignoring it
		mex('py.cpp', PYNAME, MODIFIERS);
	catch e
		cd(lastWorkingDir);
		rethrow(e);
	end

	cd(lastWorkingDir);
	
	[varargout{1:nargout}] = py(varargin{:});
end