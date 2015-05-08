



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
