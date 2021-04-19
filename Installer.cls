Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="SourceDir" Value="/opt/epcis/epcis"/>
  <Default Name="Namespace" Value="EPCIS"/>
  <Default Name="app" Value="epcis" />

  <Default Name="UserSourceDir" Value="/opt/epcis/user"/>
  <Default Name="UserNamespace" Value="USER"/>
  <Default Name="userapp" Value="user" />

  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="1">
    <Configuration>
      <ClassMapping Package="HS"
      From="HSLIB"/>
      <ClassMapping Package="HS.Local"
      From="HSCUSTOM"/>
      <ClassMapping Package="HSMOD"
      From="HSLIB"/>
      <ClassMapping Package="SchemaMap"
      From="HSLIB"/>
      <Database Name="${Namespace}" Dir="/opt/${app}/data" Create="yes" Resource="%DB_${Namespace}"/>
    </Configuration>
    <Import File="${SourceDir}" Flags="ck" Recurse="1"/>
    <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32"
                 
    />
  </Namespace>

  <Namespace Name="${UserNamespace}" Code="${UserNamespace}" Data="${UserNamespace}" Create="no" Ensemble="0">

    <Import File="${UserSourceDir}" Flags="ck" Recurse="1"/>
  </Namespace>
</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
