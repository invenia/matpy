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

% Cannot Import or Export uint64 since uint64 causes matlab to crash

%% Test UInt64 Export, it should fail
function TestUInt64Export

    function TestFunc
        numberType = 'uint64';
        expected = uint64(intmax(numberType));
        tmp = expected;

        py_export tmp;
    end

    assertExceptionThrown(@() TestFunc, 'matpy:UnsupportedVariableType');

end

%% Test UInt64 in a cell Export, it should fail
function TestUInt64CellExport

    function TestFunc
        numberType = 'uint64';
        expected = {[uint64(intmax(numberType))]};
        tmp = expected;

        py_export tmp;
    end

    assertExceptionThrown(@() TestFunc, 'matpy:UnsupportedVariableType');

end

%% Test UInt64 Import, it should fail
function TestUInt64Import

    function TestFunc
        numberType = 'uint64';
        stmt = sprintf([
                'import numpy\n' ...
                'tmp = numpy.', numberType, '(1)\n'
            ]);
        py('eval', stmt);

        py_import tmp;
    end

    assertExceptionThrown(@() TestFunc, 'matpy:UnsupportedVariableType');

end

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

%% Test logical Export and Import
function TestLogicalExportImport

    numberType = 'logical';
    expected = logical(randi([0,1]));
    tmp = expected;

    py_export tmp;
    tmp = '';
    py_import tmp;

    actual = tmp;

    assertEqual(expected, actual, [numberType, ' export and/or import not successful']);

end

% make a random number, to help with tests
function randomNum = randomNumber(numberType)
    randomNum = randi(1,1,numberType);
end

%% Test Error Messages %%

%% Test for no input
function TestNoInput

    function TestFunc
        py();
    end

    assertExceptionThrown(@() TestFunc, 'matpy:WrongNumberOfInputs');

end

%% Test for wrong input variable type
function TestWrongInputVariableTypeInput

    function TestFunc
        py(0);
    end

    assertExceptionThrown(@() TestFunc, 'matpy:WrongInputVariableType');

end

%% Test for unrecognized command
function TestUnrecognizedCommand

    function TestFunc
        py('not a real command');
    end

    assertExceptionThrown(@() TestFunc, 'matpy:UnrecognizedCommand');

end

%% Test for eval not enough inputs
function TestEvalNotEnoughInputs

    function TestFunc
        py('eval');
    end

    assertExceptionThrown(@() TestFunc, 'matpy:WrongNumberOfInputs');

end

%% Test for eval wrong input variable type
function TestEvalInputWrongVariableType

    function TestFunc
        py('eval', 2);
    end

    assertExceptionThrown(@() TestFunc, 'matpy:WrongInputVariableType');

end

%% Test for eval python error
function TestEvalPythonError

    function TestFunc
        py('eval', 'BAD_PYTHON_COMMAND');
    end

    assertExceptionThrown(@() TestFunc, 'matpy:PythonError');

end

%% Test for set not enough inputs
function TestSetNotEnoughInputs

    function TestFunc
        py('set', 'stillNotEnough');
    end

    assertExceptionThrown(@() TestFunc, 'matpy:WrongNumberOfInputs');

end

%% Test for set wrong input variable type
function TestSetInputWrongVariableType

    function TestFunc
        py('set', 2, 2);
    end

    assertExceptionThrown(@() TestFunc, 'matpy:WrongInputVariableType');

end

% %% Test for set python error TODO, make py('set', '1', 'hi'); throw an error
% function TestSetPythonError
% 
%     function TestFunc
%         py('set', '1', 'hi');
%     end
% 
%     assertExceptionThrown(@() TestFunc, 'matpy:PythonError');
% 
% end

%% Test for get not enough inputs
function TestGetNotEnoughInputs

    function TestFunc
        test = py('get');
    end

    assertExceptionThrown(@() TestFunc, 'matpy:WrongNumberOfInputs');

end

%% Test for get wrong input variable type
function TestGetInputWrongVariableType

    function TestFunc
        test = py('get', 2);
    end

    assertExceptionThrown(@() TestFunc, 'matpy:WrongInputVariableType');

end

%% Test for get no output variable
function TestGetNoOuputVariable

    function TestFunc
        py('get', 'test');
    end

    assertExceptionThrown(@() TestFunc, 'matpy:NoOutputsVariable');

end

% %% Test for get python error TODO, this tests throws an error in teardown
% function TestGetPythonError
% 
%     function TestFunc
%         test = py('get', 'Does_not_exist');
%     end
% 
%     assertExceptionThrown(@() TestFunc, 'matpy:PythonError');
% 
% end




