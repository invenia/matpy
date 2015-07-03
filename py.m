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

	[pyExecutablePath, pyIncludePath, pyLibPath, pyVersion] = getPythonPaths();
	pythonVersionNoBuildNumber = pyVersion(1:3);

	if ispc
		pythonVersionNoBuildNumber = strrep( pythonVersionNoBuildNumber, '.', '' );
	end

	PYINCLUDEDIR = ['-I', pyIncludePath];
	PYLIBPATH = ['-L', fullfile( pyLibPath, '..' )];
	PYPATH = ['''-DPYPATH=\"', pyExecutablePath, '\"'''];
	CFLAGS = ['CFLAGS="\$CFLAGS ', ' -lpython', pythonVersionNoBuildNumber, ' -ldl ', PYPATH, '"'];

	try
		mex('py.cpp', CFLAGS, '-Dchar16_t=uint16_T', PYINCLUDEDIR, PYLIBPATH);
	catch e
		cd(lastWorkingDir);
		rethrow(e);
	end

	cd(lastWorkingDir);

	[varargout{1:nargout}] = py(varargin{:});
end

function [pyExecutablePath, pyIncludePath, pyLibPath, pyVersion] = getPythonPaths()
	pyExecutablePath = getPyExecutablePath();
	pyIncludePath = getPyIncludePath(pyExecutablePath);
	pyLibPath = getPyLibPath(pyExecutablePath);
	pyVersion = getPyVersion(pyExecutablePath);
end

function executable = getPyExecutablePath()
	SUCCESS = 0;

	try
		executable = fileread( fullfile( homeDir(), '.matpyrc' ) );
	catch e
		%Failed to find custom python, using systems

		if ispc
			command = 'where python';
		else
			command = 'which python';
		end
		
		[success, executable] = system(command);

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

	if ispc
		command = [pyExecutablePath, ' -c "from distutils.sysconfig import PREFIX; print(PREFIX)"'];
	else
		command = [pyExecutablePath, ' -c "from distutils.sysconfig import get_python_lib; print(get_python_lib(False, True))"'];
	end

	[success, pyLibPath] = system(command);
	if success ~= SUCCESS
		error('Python lib could not be found');
	end

	pyLibPath = strtrim(pyLibPath);

	if ispc
		pyLibPath = fullfile( pyLibPath, 'libs' );
	end
end

function path = homeDir
	path = getenv('HOME');
	if isempty( path )
		path = [ getenv( 'HOMEDRIVE' ) getenv( 'HOMEPATH' ) ];
	end
end

function dir = mfiledir
	dir = '';

	stack = dbstack( '-completenames' );
	if numel( stack ) >= 2
		mfilepath = stack(2).file;
		dir = fileparts( mfilepath );
	end
end
