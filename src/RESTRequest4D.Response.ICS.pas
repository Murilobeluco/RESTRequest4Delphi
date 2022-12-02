unit RESTRequest4D.Response.ICS;

{$IFDEF FPC}
  {$mode delphi}
{$ENDIF}

interface

uses RESTRequest4D.Response.Contract, OverbyteIcsSslHttpRest, OverbyteIcsLogger,
  {$IFDEF FPC}
    SysUtils, fpjson, Classes, jsonparser;
  {$ELSE}
    System.SysUtils, System.JSON, System.Classes;
  {$ENDIF}

type
  TResponseICS = class(TInterfacedObject, IResponse)
  private
    FJSONValue: TJSONValue;
    FSslHttpRest: TSslHttpRest;
    FLogICS:TStringList;
    function Content: string;
    function ContentLength: Cardinal;
    function ContentType: string;
    function ContentEncoding: string;
    function ContentStream: TStream;
    function StatusCode: Integer;
    function StatusText: string;
    function RawBytes: TBytes;
    {$IFDEF FPC}
    function JSONValue: TJSONData;
    {$ELSE}
    function JSONValue: TJSONValue;
    {$ENDIF}
    function Headers: TStrings;
    procedure HttpRest1HttpRestProg(Sender: TObject;LogOption: TLogOption; const Msg: string);
    function ICSLog: String;
  public
    constructor Create(const AFSslHttpRest: TSslHttpRest);
    destructor Destroy; override;
  end;

implementation

function TResponseICS.JSONValue: TJSONValue;
var
  LContent: string;
begin
  if not(Assigned(FJSONValue)) then
  begin
    LContent := Content.Trim;
    if LContent.StartsWith('{') then
      FJSONValue := (TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LContent), 0) as TJSONObject)
    else if LContent.StartsWith('[') then
      FJSONValue := (TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LContent), 0) as TJSONArray)
    else
      raise Exception.Create('The return content is not a valid JSON value.');
  end;
  Result := FJSONValue;
end;

function TResponseICS.RawBytes: TBytes;
begin
  Result := TBytesStream(FSslHttpRest.ResponseStream).Bytes;
end;

function TResponseICS.Content: string;
begin
  Result := FSslHttpRest.ResponseRaw;
end;

function TResponseICS.ICSLog:String;
begin
  Result := FLogICS.Text;
end;

function TResponseICS.Headers:TStrings;
var
  I: Integer;
begin
  Result := TStringList.Create;
  Result.NameValueSeparator := ':';
  for I := 1 to Pred(FSslHttpRest.RcvdHeader.Count) do
    Result.Values[Copy(FSslHttpRest.RcvdHeader.KeyNames[i], 0, Pos(':', FSslHttpRest.RcvdHeader.KeyNames[i])-1)] := Copy(FSslHttpRest.RcvdHeader.KeyNames[i], Pos(':', FSslHttpRest.RcvdHeader.KeyNames[i])+1, length(FSslHttpRest.RcvdHeader.KeyNames[i]))
end;

procedure TResponseICS.HttpRest1HttpRestProg(Sender: TObject; LogOption: TLogOption; const Msg: string);
begin
  FLogICS.Add(Msg);
end;

function TResponseICS.StatusCode: Integer;
begin
  Result := FSslHttpRest.StatusCode;
end;

function TResponseICS.StatusText: string;
begin
  Result := FSslHttpRest.ReasonPhrase;
end;

function TResponseICS.ContentEncoding: string;
begin
  Result := FSslHttpRest.ContentEncoding;
end;

function TResponseICS.ContentLength: Cardinal;
begin
  Result := FSslHttpRest.ContentLength;
end;

function TResponseICS.ContentStream: TStream;
begin
  Result := FSslHttpRest.ResponseStream;
  Result.Position := 0;
end;

function TResponseICS.ContentType: string;
begin
  Result := FSslHttpRest.ContentType;
end;

constructor TResponseICS.Create(const AFSslHttpRest: TSslHttpRest);
begin
  FSslHttpRest := AFSslHttpRest;
  FLogICS := TStringList.Create;
  FSslHttpRest.OnHttpRestProg := HttpRest1HttpRestProg;
end;

destructor TResponseICS.Destroy;
begin
  if Assigned(FJSONValue) then
    FreeAndNil(FJSONValue);
  FreeAndNil(FLogICS);
  inherited;
end;


end.

