function suite = TestQuery
	initTestSuite;
end

function Setup
    stmt = sprintf(['actual = -1\n']);
    py('eval', stmt);
end

function TearDown
    stmt = sprintf(['actual = -1\n']);
    py('eval', stmt);
end

%% Test String Import
function TestStringImport

    symbols = ['a':'z' 'A':'Z' '0':'9'];
    MAX_ST_LENGTH = 50;
    strLength = randi(MAX_ST_LENGTH);
    nums = randi(numel(symbols),[1 strLength]);
    expected = symbols (nums);

    stmt = sprintf([    
                        'actual = "' ...
                        expected ...
                        '"\n'
                    ]);

    py('eval', stmt);

    py_import actual

    assertEqual(expected, actual, 'string import not successful')

end
