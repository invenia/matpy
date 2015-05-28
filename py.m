% Converts string to double precision value. The string may contain digits,
% commas (thousands separator), a decimal point, a leading + or - sign,
% an 'e' preceding a power of 10 scale factor, and an 'i' for a complex 
% unit. 
% 


% 
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
% 	tmp = py('eval', 'print "hi"')
% 


%
% If the string does not represent a valid scalar value a NaN is
% returned instead.
%
% Inputs:
%   Char or Cellstr, converts the strings into double precision values. If
%     a cell is given a matrix will be returned of the same dimensions. NaN
%     values will be returned for non-parsable strings.
%
% Outputs:
%   Double Matrix, a scalar double if a char was given or a matrix of the s
%     size of the given cellstr.
%
% Examples:
%   str2double( '123.45e7' )
%   str2double( '123 + 45i' )
%   str2double( '3.14159' )
%   str2double( '2.7i - 3.14' )
%   str2double( { '2.71' '3.1415' } )
%   str2double( '1,200.34' )
%
% See also: str2num, num2str, hex2num, char.

% 25 August 2011
% Curtis Vogt
% Added comments and automatic compiling to help function.

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