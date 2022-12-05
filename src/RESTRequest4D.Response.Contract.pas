unit RESTRequest4D.Response.Contract;

interface

uses
  {$IF DEFINED(FPC)}
    SysUtils, Classes, fpjson;
  {$ELSE}
    System.SysUtils, System.JSON, System.Classes;
  {$ENDIF}

type
  IResponse = interface
    ['{A3BB1797-E99E-4C72-8C4A-925825A50C27}']
    function Content: string;
    function ContentType: string;
    function ContentEncoding: string;
    function ContentStream: TStream;
    function StatusCode: Integer;
    function StatusText: string;
    function RawBytes: TBytes;
    function Headers: TStrings;
  {$IF DEFINED(FPC)}
    function JSONValue: TJSONData;
  {$ELSE}
    function JSONValue: TJSONValue;
  {$ENDIF}
  {$IF DEFINED(RR4D_ICS)}
  function ICSLog: String;
  function ContentLength: int64;
  {$ELSE}
  function ContentLength: Cardinal;
  {$ENDIF}

  end;

implementation

end.
