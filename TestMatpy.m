function suite = TestQuery
	initTestSuite;
end

function Setup
    stmt = sprintf(['tmp = -1\n']);
    py('eval', stmt);
end

function TearDown
    stmt = sprintf(['tmp = -1\n']);
    py('eval', stmt);
end

%% Test String Export and Import
function TestStringImport

    symbols = ['a':'z' 'A':'Z' '0':'9'];
    MAX_ST_LENGTH = 50;
    strLength = randi(MAX_ST_LENGTH);
    nums = randi(numel(symbols),[1 strLength]);
    expected = symbols (nums);
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, 'string export and/or import not successful');

end

%% Test Unicode String Import
function TestUnicodeStringImport

    symbols = ['a':'z' 'A':'Z' '0':'9'];
    MAX_ST_LENGTH = 50;
    strLength = randi(MAX_ST_LENGTH);
    nums = randi(numel(symbols),[1 strLength]);
    expected = symbols (nums);

    stmt = sprintf(['tmp = u"', expected, '"\n']);

    py('eval', stmt);

    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, 'unicode string import not successful');

end

%% Test Int8 Export and Import
function TestInt8ExportImport

    numberType = 'int8';
    expected = int8(randomNumber(numberType));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end

%% Test UInt8 Export and Import
function TestUInt8ExportImport

    numberType = 'uint8';
    expected = uint8(randomNumber(numberType));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end


%% Test Int16 Export and Import
function TestInt16ExportImport

    numberType = 'int16';
    expected = int16(randomNumber(numberType));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end

%% Test UInt16 Export and Import
function TestUInt16ExportImport

    numberType = 'uint16';
    expected = uint16(randomNumber(numberType));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end


%% Test Int32 Export and Import
function TestInt32ExportImport

    numberType = 'int32';
    expected = int32(randomNumber(numberType));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end

%% Test UInt32 Export and Import
function TestUInt32ExportImport

    numberType = 'uint32';
    expected = uint32(randomNumber(numberType));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end


%% Test Int64 Export and Import
function TestInt64ExportImport

    numberType = 'int64';
    expected = int64(intmax(numberType)); % randi does not support 'int64'
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end

%  %% Test UInt64 Export and Import
%  function TestUInt64ExportImport
%  
%      numberType = 'uint64';
%      expected = uint64(intmax(numberType));
%      tmp = expected;
%  
%      py_export tmp;
%      tmp = '';
%      py_import tmp;
%  
%      actual = tmp;
%  
%      assertEqual(expected, actual, [numberType, ' export and/or import not successful']);
%  
%  end


%% Test single Export and Import
function TestSingleExportImport

    numberType = 'single';
    expected = single(randomNumber(numberType));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end


%% Test double Export and Import
function TestDoubleExportImport

    numberType = 'double';
    expected = double(randomNumber(numberType));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end

function randomNum = randomNumber(numberType)
    randomNum = randi(1,1,numberType);
end


