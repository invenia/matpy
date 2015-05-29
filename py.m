% A way to interact with python from matlab.
%
% Inputs:
% 	1) the type of command, which can be any of the following:
% 		a. 'eval' this will run the second parameter as python
% 		b. 'set'  this will export the third value by name of second parameter to python
% 		c. 'get'  this will import the second parameter from python by name
% 		d. 'debugon'  used for debugging
% 		c. 'debugoff' used for debugging (default is this)
% 	2) this parameter will interact with python depending on what is passed in
% 		the first parameter, see above for what that would be
%	3) only for 'set' command, see above
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

	[execPrefix pythonVersion] = getParsedPypath();

	PYINCLUDEDIR = ['-I', getPyIncludePath(execPrefix, pythonVersion)];
	PYLIBPATH = ['-L', execPrefix, '/../lib/python', pythonVersion];
	PYPATH = ['''-DPYPATH=\"', execPrefix, '/python', '\"'''];
	CFLAGS = ['CFLAGS="\$CFLAGS ', ' -lpython2.7 ', PYPATH, '"'];

	try
		mex('py.cpp', CFLAGS, '-Dchar16_t=uint16_T', PYINCLUDEDIR, PYLIBPATH);
	catch e
		cd(lastWorkingDir);
		rethrow(e);
	end

	cd(lastWorkingDir);

	[varargout{1:nargout}] = py(varargin{:});
end

function [execPrefix, pythonVersion] = getParsedPypath()
	executable = getPypath();
	pythonVersion = getPythonVersion(executable);
	tokens = splitBySlash(executable);
	execPrefix = ['/', fullfile(tokens{1:end-1})];
end

function tokens = splitBySlash(str)
	tokens = strread(str, '%s', 'delimiter', '/');
end

function executable = getPypath()

	SUCCESS = 0;
	[success, executable] = system('cat ~/.matpyrc');

	if success ~= SUCCESS
		%Failed to find custom python, using systems

		[success, executable] = system('which python');

		if success ~= SUCCESS
			error('Python could not be found');
		end
	end

	executable = strtrim(executable);

end

function pythonVersion = getPythonVersion(executable)
	SUCCESS = 0;
	[success pythonVersion] = system([executable, ' -c "import platform; print(platform.python_version()[:3])"']);

	if success ~= SUCCESS
		error('Could not get version number of python');
	end
	pythonVersion = strtrim(pythonVersion);
end

function pyIncludePath = getPyIncludePath(execPrefix, pythonVersion)
	pyIncludePath = [execPrefix, '/../include/python', pythonVersion];

	FOLDER_FOUND = 7;
	result = exist(pyIncludePath, 'dir');

	if(result ~= FOLDER_FOUND)
		% there's a chance that the python include path has an m on the end of it
		pyIncludePath = [pyIncludePath, 'm'];
	end
end