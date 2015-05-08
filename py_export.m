function py_export(varargin)
	for i=1:numel(varargin)
		py('set', varargin{i}, evalin('caller',varargin{i}));
	end
end
