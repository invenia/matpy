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

	[pyExecutablePath, pyIncludePath, pyLibPath, pyVersion] = getPythonPaths()
	pythonVersionNoBuildNumber = pyVersion(1:3);

	PYINCLUDEDIR = ['-I', pyIncludePath];
	PYLIBPATH = ['-L', pyLibPath];
	PYPATH = ['''-DPYPATH=\"', pyExecutablePath, '\"'''];
	CFLAGS = ['CFLAGS="\$CFLAGS ', ' -lpython', pythonVersionNoBuildNumber, ' ', PYPATH, '"'];

	try
		mex('py.cpp', CFLAGS, '-Dchar16_t=uint16_T', PYINCLUDEDIR, PYLIBPATH);
	catch e
		cd(lastWorkingDir);
		sprintf('CFLAGS: %s\nPYINCLUDER: %s\nPYLIBPATH: %s\n', CFLAGS, PYINCLUDEDIR, PYLIBPATH)
		rethrow(e);
	end

	cd(lastWorkingDir);

	[varargout{1:nargout}] = py(varargin{:});
end

function [pyExecutablePath, pyIncludePath, pyLibPath, pyVersion] = getPythonPaths()
	
	SUCCESS = 0;
	pyExecutablePath = getPyExecutablePath();
	pyIncludePath = getPyIncludePath(pyExecutablePath);
	pyLibPath = getPyLibPath(pyExecutablePath);
	pyVersion = getPyVersion(pyExecutablePath);

end

function executable = getPyExecutablePath()

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

function pyVersion = getPyVersion(pyExecutablePath)
	SUCCESS = 0;
	[success pyVersion] = system([pyExecutablePath, ' -c "import platform; print(platform.python_version())"']);

	if success ~= SUCCESS
		error('Could not get version number of python');
	end
	pyVersion = strtrim(pyVersion);
end

function pyIncludePath = getPyIncludePath(pyExecutablePath)
	SUCCESS = 0;
	[success, pyIncludePath] = system([pyExecutablePath, ' -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())"']);
	if success ~= SUCCESS
		error('Python include could not be found');
	end
	pyIncludePath = strtrim(pyIncludePath);
end

function pyLibPath = getPyLibPath(pyExecutablePath)
	SUCCESS = 0;
	[success, pyLibPath] = system([pyExecutablePath, ' -c "from distutils.sysconfig import get_python_lib; print(get_python_lib)()"']);
	if success ~= SUCCESS
		error('Python lib could not be found');
	end

	tokens = splitBySlash(pyLibPath);
	if strcmp(tokens(end), 'site-packages')
		pyLibPath = ['/', fullfile(tokens{1:end-1})];
	end
	pyLibPath = strtrim(pyLibPath);
end

function tokens = splitBySlash(str)
	tokens = strread(str, '%s', 'delimiter', '/');
end