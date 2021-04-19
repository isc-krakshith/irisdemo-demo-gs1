Class EPCIS.intersystems.AppRestService Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
      <Route Url="/encounter" Method="GET" Call="FHIRbundle"/>
     <Route Url="/activitydefinition" Method="GET" Call="FHIRbundle"/>
   </Routes>
}

ClassMethod FHIRbundle() As %Status
{
	set tSC=$$$OK
	#dim %request As %CSP.Request
	set tRequest=##class(EPCIS.intersystems.EventQueryRequest).%New()
	set name=""
	set name=$order(%request.Data(name))
	while (name'="") {
		set param=##class(EPCIS.epcisq.QueryParam).%New()
		set param.name=name
		set param.value=%request.Data(name,1)
		set name=$order(%request.Data(name))
		do tRequest.QueryParams.Insert(param)
	}
	// Create the business service 
  	Set tSC=##class(Ens.Director).CreateBusinessService("App Query Service",.tService) 
  	If ($$$ISERR(tSC)) Quit tSC
  	
  	
  	// Call the ProcessInput method of the business service 
  	Set tSC=tService.ProcessInput(tRequest,.output) 
  	If ($$$ISERR(tSC)) Quit tSC
  	#dim output As HS.Message.FHIR.Response
  	if $isobject(output) {
	  	do output.Payload.OutputToDevice()
  	}
	quit tSC
}

ClassMethod GetJSONFromRequest(obj As %DynamicObject) As %Boolean
{
	Set ok = 1
	Try {
		set ^DEBUG=%request.Content.Read()
		Set obj = ##class(%DynamicObject).%FromJSON(%request.Content)
	} Catch ex {
		Set ok = 0
	}
	Quit ok
}

ClassMethod ValidateJSON(obj As %DynamicObject, error As %DynamicObject) As %Boolean
{
	Set error = {}
	
	If obj.%Get("EPCISDocument") = "" {
		Set error.errormessage = "EPCISDocument was blank"
		Quit 0
	}	
	
	Quit 1
}

ClassMethod CopyToEpcisDocumentFromJSON(doc As EPCIS.epcis.EPCISDocumentType, obj As %DynamicObject) As %Status
{
	set tSC=$$$OK
	
	set xml=obj.%Get("EPCISDocument")
	set reader=##class(%XML.Reader).%New()
	set tSC = reader.OpenString(xml)
	
	If ($$$ISERR(tSC)) Quit tSC
	
	do reader.Correlate("EPCISDocument","EPCIS.epcis.EPCISDocumentType")
	while reader.Next(.doc,.tSC) {
		break
	}
	set ^DEBUG("doc")=doc
	quit tSC
}

}
