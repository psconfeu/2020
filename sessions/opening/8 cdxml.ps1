

#region create cdxml
$folder = "c:\wmi\Win32_OperatingSystem"
$cdxmlPath = Join-Path -Path $folder -ChildPath "Win32_OperatingSystem.cdxml"

# create folder if not present:
$exists = Test-Path -Path $folder
if (!$exists) { $null = New-Item -Path $folder -ItemType Directory }

# write file
$content = @'
<?xml version="1.0" encoding="utf-8"?>


<!--
This file is licensed under 'Attribution 4.0 International' license (https://creativecommons.org/licenses/by/4.0/).

You can free of charge use this code in commercial and non-commercial code, and you can freely modify and adjust the code 
as long as you give appropriate credit to the original author Dr. Tobias Weltner.

This material was published and is maintained here: 

https://powershell.one/wmi/root/cimv2/win32_operatingsystem#cdxml-definition
-->


<PowerShellMetadata xmlns="http://schemas.microsoft.com/cmdlets-over-objects/2009/11">
  <!--referencing the WMI class this cdxml uses-->
  <Class ClassName="Root/CIMV2\Win32_OperatingSystem" ClassVersion="2.0">
    <Version>1.0</Version>
    <!--default noun used by Get-cmdlets and when no other noun is specified. By convention, we use the prefix "WMI" and the base name of the WMI class involved. This way, you can easily identify the underlying WMI class.-->
    <DefaultNoun>WmiOperatingSystem</DefaultNoun>
    <!--define the cmdlets that work with class instances.-->
    <InstanceCmdlets>
      <!--query parameters to select instances. This is typically empty for classes that provide only one instance-->
      <GetCmdletParameters />
      <!--defining additional cmdlets that modifies instance properties-->
      <!--Set-OperatingSystem: modifying instance properties-->
      <Cmdlet>
        <!--defining the ConfirmImpact which indicates how severe the changes are that this cmdlet performs-->
        <CmdletMetadata Verb="Set" ConfirmImpact="Low" />
        <!--using internal method to modify instance:-->
        <Method MethodName="cim:ModifyInstance">
          <!--defining the parameters of this cmdlet:-->
          <Parameters>
            <Parameter ParameterName="Description">
              <!--the underlying parameter type is string which corresponds to the PowerShell .NET type [system.string]-->
              <Type PSType="system.string" />
              <CmdletParameterMetadata IsMandatory="false">
                <ValidateNotNull />
                <ValidateNotNullOrEmpty />
              </CmdletParameterMetadata>
            </Parameter>
            <Parameter ParameterName="ForegroundApplicationBoost">
              <!--the underlying parameter type is uint8 which really is the enumeration [Win32_OperatingSystem.ForegroundApplicationBoost] that is defined below in the Enums node:-->
              <Type PSType="Win32_OperatingSystem.ForegroundApplicationBoost" />
              <CmdletParameterMetadata IsMandatory="false">
                <ValidateNotNull />
                <ValidateNotNullOrEmpty />
              </CmdletParameterMetadata>
            </Parameter>
          </Parameters>
        </Method>
      </Cmdlet>
      <!--Invoke-OperatingSystemReboot: invoking method Reboot():-->
      <Cmdlet>
        <!--defining the ConfirmImpact which indicates how severe the changes are that this cmdlet performs-->
        <CmdletMetadata Verb="Invoke" Noun="WmiOperatingSystemReboot" ConfirmImpact="High" />
        <!--defining the WMI instance method used by this cmdlet:-->
        <Method MethodName="Reboot">
          <ReturnValue>
            <Type PSType="system.uint32" />
            <CmdletOutputMetadata>
              <ErrorCode />
            </CmdletOutputMetadata>
          </ReturnValue>
        </Method>
      </Cmdlet>
      <!--Set-OperatingSystemDateTime: invoking method SetDateTime():-->
      <Cmdlet>
        <!--defining the ConfirmImpact which indicates how severe the changes are that this cmdlet performs-->
        <CmdletMetadata Verb="Set" Noun="WmiOperatingSystemDateTime" ConfirmImpact="High" />
        <!--defining the WMI instance method used by this cmdlet:-->
        <Method MethodName="SetDateTime">
          <ReturnValue>
            <Type PSType="system.uint32" />
            <CmdletOutputMetadata>
              <ErrorCode />
            </CmdletOutputMetadata>
          </ReturnValue>
          <!--defining the parameters of this cmdlet:-->
          <Parameters>
            <!--native parameter name is 'LocalDateTime'-->
            <Parameter ParameterName="LocalDateTime">
              <!--the underlying parameter type is DateTime which corresponds to the PowerShell .NET type [system.DateTime]-->
              <Type PSType="system.DateTime" />
              <CmdletParameterMetadata Position="0" IsMandatory="false">
                <ValidateNotNull />
                <ValidateNotNullOrEmpty />
              </CmdletParameterMetadata>
            </Parameter>
          </Parameters>
        </Method>
      </Cmdlet>
      <!--Invoke-OperatingSystemShutdown: invoking method Shutdown():-->
      <Cmdlet>
        <!--defining the ConfirmImpact which indicates how severe the changes are that this cmdlet performs-->
        <CmdletMetadata Verb="Invoke" Noun="WmiOperatingSystemShutdown" ConfirmImpact="High" />
        <!--defining the WMI instance method used by this cmdlet:-->
        <Method MethodName="Shutdown">
          <ReturnValue>
            <Type PSType="system.uint32" />
            <CmdletOutputMetadata>
              <ErrorCode />
            </CmdletOutputMetadata>
          </ReturnValue>
        </Method>
      </Cmdlet>
      <!--Invoke-OperatingSystemWin32Shutdown: invoking method Win32Shutdown():-->
      <Cmdlet>
        <!--defining the ConfirmImpact which indicates how severe the changes are that this cmdlet performs-->
        <CmdletMetadata Verb="Invoke" Noun="WmiOperatingSystemWin32Shutdown" ConfirmImpact="High" />
        <!--defining the WMI instance method used by this cmdlet:-->
        <Method MethodName="Win32Shutdown">
          <ReturnValue>
            <Type PSType="system.uint32" />
            <CmdletOutputMetadata>
              <ErrorCode />
            </CmdletOutputMetadata>
          </ReturnValue>
          <!--defining the parameters of this cmdlet:-->
          <Parameters>
            <!--native parameter name is 'Flags'-->
            <Parameter ParameterName="Flags">
              <!--the underlying parameter type is SInt32 which really is the enumeration [Win32_OperatingSystem.Flags] that is defined below in the Enums node:-->
              <Type PSType="Win32_OperatingSystem.Flags" />
              <CmdletParameterMetadata Position="0" IsMandatory="false">
                <ValidateNotNull />
                <ValidateNotNullOrEmpty />
              </CmdletParameterMetadata>
            </Parameter>
          </Parameters>
        </Method>
      </Cmdlet>
      <!--Invoke-OperatingSystemWin32ShutdownTracker: invoking method Win32ShutdownTracker():-->
      <Cmdlet>
        <!--defining the ConfirmImpact which indicates how severe the changes are that this cmdlet performs-->
        <CmdletMetadata Verb="Invoke" Noun="WmiOperatingSystemWin32ShutdownTracker" Aliases="ShutdownTracker wost" ConfirmImpact="High" />
        <!--defining the WMI instance method used by this cmdlet:-->
        <Method MethodName="Win32ShutdownTracker">
          <ReturnValue>
            <Type PSType="system.uint32" />
            <CmdletOutputMetadata>
              <ErrorCode />
            </CmdletOutputMetadata>
          </ReturnValue>
          <!--defining the parameters of this cmdlet:-->
          <Parameters>
            <!--native parameter name is 'Flags'-->
            <Parameter ParameterName="Flags">
              <!--the underlying parameter type is SInt32 which really is the enumeration [Win32_OperatingSystem.Flags] that is defined below in the Enums node:-->
              <Type PSType="Win32_OperatingSystem.Flags" />
              <CmdletParameterMetadata Position="0" IsMandatory="false">
                <ValidateNotNull />
                <ValidateNotNullOrEmpty />
              </CmdletParameterMetadata>
            </Parameter>
            <!--native parameter name is 'Timeout'-->
            <Parameter ParameterName="Timeout">
              <!--the underlying parameter type is UInt32 which corresponds to the PowerShell .NET type [system.UInt32]-->
              <Type PSType="system.UInt32" />
              <CmdletParameterMetadata Position="1" IsMandatory="false">
                <ValidateNotNull />
                <ValidateNotNullOrEmpty />
              </CmdletParameterMetadata>
            </Parameter>
            <!--native parameter name is 'Comment'-->
            <Parameter ParameterName="Comment">
              <!--the underlying parameter type is String which corresponds to the PowerShell .NET type [system.String]-->
              <Type PSType="system.String" />
              <CmdletParameterMetadata Position="2" IsMandatory="false">
                <ValidateNotNull />
                <ValidateNotNullOrEmpty />
              </CmdletParameterMetadata>
            </Parameter>
            <!--native parameter name is 'ReasonCode'-->
            <Parameter ParameterName="ReasonCode">
              <!--the underlying parameter type is UInt32 which corresponds to the PowerShell .NET type [system.UInt32]-->
              <Type PSType="system.UInt32" />
              <CmdletParameterMetadata Position="3" IsMandatory="false">
                <ValidateNotNull />
                <ValidateNotNullOrEmpty />
              </CmdletParameterMetadata>
            </Parameter>
          </Parameters>
        </Method>
      </Cmdlet>
    </InstanceCmdlets>
  </Class>
  <!--defining enumerations-->
  <Enums>
    <Enum EnumName="Win32_OperatingSystem.DataExecutionPrevention_SupportPolicy" UnderlyingType="byte">
      <Value Name="AlwaysOff" Value="0" />
      <Value Name="AlwaysOn" Value="1" />
      <Value Name="OptIn" Value="2" />
      <Value Name="OptOut" Value="3" />
    </Enum>
    <Enum EnumName="Win32_OperatingSystem.Flags" UnderlyingType="int" BitwiseFlags="true">
      <Value Name="Logoff" Value="0" />
      <Value Name="Shutdown" Value="1" />
      <Value Name="Reboot" Value="2" />
      <Value Name="Force" Value="4" />
      <Value Name="PowerOff" Value="8" />
    </Enum>
    <Enum EnumName="Win32_OperatingSystem.ForegroundApplicationBoost" UnderlyingType="byte">
      <Value Name="None" Value="0" />
      <Value Name="Minimum" Value="1" />
      <Value Name="Maximum" Value="2" />
    </Enum>
    <Enum EnumName="Win32_OperatingSystem.OperatingSystemSKU" UnderlyingType="system.uint32">
      <Value Name="PRODUCTUNDEFINED" Value="0" />
      <Value Name="PRODUCTULTIMATE" Value="1" />
      <Value Name="PRODUCTHOMEBASIC" Value="2" />
      <Value Name="PRODUCTHOMEPREMIUM" Value="3" />
      <Value Name="PRODUCTENTERPRISE" Value="4" />
      <Value Name="PRODUCTHOMEBASICN" Value="5" />
      <Value Name="PRODUCTBUSINESS" Value="6" />
      <Value Name="PRODUCTSTANDARDSERVER" Value="7" />
      <Value Name="PRODUCTDATACENTERSERVER" Value="8" />
      <Value Name="PRODUCTSMALLBUSINESSSERVER" Value="9" />
      <Value Name="PRODUCTENTERPRISESERVER" Value="10" />
      <Value Name="PRODUCTSTARTER" Value="11" />
      <Value Name="PRODUCTDATACENTERSERVERCORE" Value="12" />
      <Value Name="PRODUCTSTANDARDSERVERCORE" Value="13" />
      <Value Name="PRODUCTENTERPRISESERVERCORE" Value="14" />
      <Value Name="PRODUCTENTERPRISESERVERIA64" Value="15" />
      <Value Name="PRODUCTBUSINESSN" Value="16" />
      <Value Name="PRODUCTWEBSERVER" Value="17" />
      <Value Name="PRODUCTCLUSTERSERVER" Value="18" />
      <Value Name="PRODUCTHOMESERVER" Value="19" />
      <Value Name="PRODUCTSTORAGEEXPRESSSERVER" Value="20" />
      <Value Name="PRODUCTSTORAGESTANDARDSERVER" Value="21" />
      <Value Name="PRODUCTSTORAGEWORKGROUPSERVER" Value="22" />
      <Value Name="PRODUCTSTORAGEENTERPRISESERVER" Value="23" />
      <Value Name="PRODUCTSERVERFORSMALLBUSINESS" Value="24" />
      <Value Name="PRODUCTSMALLBUSINESSSERVERPREMIUM" Value="25" />
      <Value Name="PRODUCTHOMEPREMIUMN" Value="26" />
      <Value Name="PRODUCTENTERPRISEN" Value="27" />
      <Value Name="PRODUCTULTIMATEN" Value="28" />
      <Value Name="PRODUCTWEBSERVERCORE" Value="29" />
      <Value Name="PRODUCTMEDIUMBUSINESSSERVERMANAGEMENT" Value="30" />
      <Value Name="PRODUCTMEDIUMBUSINESSSERVERSECURITY" Value="31" />
      <Value Name="PRODUCTMEDIUMBUSINESSSERVERMESSAGING" Value="32" />
      <Value Name="PRODUCTSERVERFOUNDATION" Value="33" />
      <Value Name="PRODUCTHOMEPREMIUMSERVER" Value="34" />
      <Value Name="PRODUCTSERVERFORSMALLBUSINESSV" Value="35" />
      <Value Name="PRODUCTSTANDARDSERVERV" Value="36" />
      <Value Name="PRODUCTDATACENTERSERVERV" Value="37" />
      <Value Name="PRODUCTENTERPRISESERVERV" Value="38" />
      <Value Name="PRODUCTDATACENTERSERVERCOREV" Value="39" />
      <Value Name="PRODUCTSTANDARDSERVERCOREV" Value="40" />
      <Value Name="PRODUCTENTERPRISESERVERCOREV" Value="41" />
      <Value Name="PRODUCTHYPERV" Value="42" />
      <Value Name="PRODUCTSTORAGEEXPRESSSERVERCORE" Value="43" />
      <Value Name="PRODUCTSTORAGESTANDARDSERVERCORE" Value="44" />
      <Value Name="PRODUCTSTORAGEWORKGROUPSERVERCORE" Value="45" />
      <Value Name="PRODUCTSTORAGEENTERPRISESERVERCORE" Value="46" />
      <Value Name="PRODUCTSTARTERN" Value="47" />
      <Value Name="PRODUCTPROFESSIONAL" Value="48" />
      <Value Name="PRODUCTPROFESSIONALN" Value="49" />
      <Value Name="PRODUCTSBSOLUTIONSERVER" Value="50" />
      <Value Name="PRODUCTSERVERFORSBSOLUTIONS" Value="51" />
      <Value Name="PRODUCTSTANDARDSERVERSOLUTIONS" Value="52" />
      <Value Name="PRODUCTSTANDARDSERVERSOLUTIONSCORE" Value="53" />
      <Value Name="PRODUCTSBSOLUTIONSERVEREM" Value="54" />
      <Value Name="PRODUCTSERVERFORSBSOLUTIONSEM" Value="55" />
      <Value Name="PRODUCTSOLUTIONEMBEDDEDSERVER" Value="56" />
      <Value Name="PRODUCTSOLUTIONEMBEDDEDSERVERCORE" Value="57" />
      <Value Name="PRODUCTPROFESSIONALEMBEDDED" Value="58" />
      <Value Name="PRODUCTESSENTIALBUSINESSSERVERMGMT" Value="59" />
      <Value Name="PRODUCTESSENTIALBUSINESSSERVERADDL" Value="60" />
      <Value Name="PRODUCTESSENTIALBUSINESSSERVERMGMTSVC" Value="61" />
      <Value Name="PRODUCTESSENTIALBUSINESSSERVERADDLSVC" Value="62" />
      <Value Name="PRODUCTSMALLBUSINESSSERVERPREMIUMCORE" Value="63" />
      <Value Name="PRODUCTCLUSTERSERVERV" Value="64" />
      <Value Name="PRODUCTEMBEDDED" Value="65" />
      <Value Name="PRODUCTSTARTERE" Value="66" />
      <Value Name="PRODUCTHOMEBASICE" Value="67" />
      <Value Name="PRODUCTHOMEPREMIUME" Value="68" />
      <Value Name="PRODUCTPROFESSIONALE" Value="69" />
      <Value Name="PRODUCTENTERPRISEE" Value="70" />
      <Value Name="PRODUCTULTIMATEE" Value="71" />
      <Value Name="PRODUCTENTERPRISEEVALUATION" Value="72" />
      <Value Name="PRODUCTMULTIPOINTSTANDARDSERVER" Value="76" />
      <Value Name="PRODUCTMULTIPOINTPREMIUMSERVER" Value="77" />
      <Value Name="PRODUCTSTANDARDEVALUATIONSERVER" Value="79" />
      <Value Name="PRODUCTDATACENTEREVALUATIONSERVER" Value="80" />
      <Value Name="PRODUCTENTERPRISENEVALUATION" Value="84" />
      <Value Name="PRODUCTEMBEDDEDAUTOMOTIVE" Value="85" />
      <Value Name="PRODUCTEMBEDDEDINDUSTRYA" Value="86" />
      <Value Name="PRODUCTTHINPC" Value="87" />
      <Value Name="PRODUCTEMBEDDEDA" Value="88" />
      <Value Name="PRODUCTEMBEDDEDINDUSTRY" Value="89" />
      <Value Name="PRODUCTEMBEDDEDE" Value="90" />
      <Value Name="PRODUCTEMBEDDEDINDUSTRYE" Value="91" />
      <Value Name="PRODUCTEMBEDDEDINDUSTRYAE" Value="92" />
      <Value Name="PRODUCTSTORAGEWORKGROUPEVALUATIONSERVE" Value="95" />
      <Value Name="PRODUCTSTORAGESTANDARDEVALUATIONSERVER" Value="96" />
      <Value Name="PRODUCTCOREARM" Value="97" />
      <Value Name="PRODUCTCOREN" Value="98" />
      <Value Name="PRODUCTCORECOUNTRYSPECIFIC" Value="99" />
      <Value Name="PRODUCTCORESINGLELANGUAGE" Value="100" />
      <Value Name="PRODUCTCORE" Value="101" />
      <Value Name="PRODUCTPROFESSIONALWMC" Value="103" />
      <Value Name="PRODUCTEMBEDDEDINDUSTRYEVAL" Value="105" />
      <Value Name="PRODUCTEMBEDDEDINDUSTRYEEVAL" Value="106" />
      <Value Name="PRODUCTEMBEDDEDEVAL" Value="107" />
      <Value Name="PRODUCTEMBEDDEDEEVAL" Value="108" />
      <Value Name="PRODUCTNANOSERVER" Value="109" />
      <Value Name="PRODUCTCLOUDSTORAGESERVER" Value="110" />
      <Value Name="PRODUCTCORECONNECTED" Value="111" />
      <Value Name="PRODUCTPROFESSIONALSTUDENT" Value="112" />
      <Value Name="PRODUCTCORECONNECTEDN" Value="113" />
      <Value Name="PRODUCTPROFESSIONALSTUDENTN" Value="114" />
      <Value Name="PRODUCTCORECONNECTEDSINGLELANGUAGE" Value="115" />
      <Value Name="PRODUCTCORECONNECTEDCOUNTRYSPECIFIC" Value="116" />
      <Value Name="PRODUCTCONNECTEDCAR" Value="117" />
      <Value Name="PRODUCTINDUSTRYHANDHELD" Value="118" />
      <Value Name="PRODUCTPPIPRO" Value="119" />
      <Value Name="PRODUCTARM64SERVER" Value="120" />
      <Value Name="PRODUCTEDUCATION" Value="121" />
      <Value Name="PRODUCTEDUCATIONN" Value="122" />
      <Value Name="PRODUCTIOTUAP" Value="123" />
      <Value Name="PRODUCTCLOUDHOSTINFRASTRUCTURESERVER" Value="124" />
      <Value Name="PRODUCTENTERPRISES" Value="125" />
      <Value Name="PRODUCTENTERPRISESN" Value="126" />
      <Value Name="PRODUCTPROFESSIONALS" Value="127" />
      <Value Name="PRODUCTPROFESSIONALSN" Value="128" />
      <Value Name="PRODUCTENTERPRISESEVALUATION" Value="129" />
      <Value Name="PRODUCTENTERPRISESNEVALUATION" Value="130" />
      <Value Name="PRODUCTHOLOGRAPHIC" Value="135" />
      <Value Name="PRODUCTPROSINGLELANGUAGE" Value="138" />
      <Value Name="PRODUCTPROCHINA" Value="139" />
      <Value Name="PRODUCTENTERPRISESUBSCRIPTION" Value="140" />
      <Value Name="PRODUCTENTERPRISESUBSCRIPTIONN" Value="141" />
      <Value Name="PRODUCTDATACENTERNANOSERVER" Value="143" />
      <Value Name="PRODUCTSTANDARDNANOSERVER" Value="144" />
      <Value Name="PRODUCTDATACENTERASERVERCORE" Value="145" />
      <Value Name="PRODUCTSTANDARDASERVERCORE" Value="146" />
      <Value Name="PRODUCTDATACENTERWSSERVERCORE" Value="147" />
      <Value Name="PRODUCTSTANDARDWSSERVERCORE" Value="148" />
      <Value Name="PRODUCTUTILITYVM" Value="149" />
      <Value Name="PRODUCTDATACENTEREVALUATIONSERVERCORE" Value="159" />
      <Value Name="PRODUCTSTANDARDEVALUATIONSERVERCORE" Value="160" />
      <Value Name="PRODUCTPROWORKSTATION" Value="161" />
      <Value Name="PRODUCTPROWORKSTATIONN" Value="162" />
      <Value Name="PRODUCTPROFOREDUCATION" Value="164" />
      <Value Name="PRODUCTPROFOREDUCATIONN" Value="165" />
      <Value Name="PRODUCTAZURESERVERCORE" Value="168" />
      <Value Name="PRODUCTAZURENANOSERVER" Value="169" />
      <Value Name="PRODUCTENTERPRISEG" Value="171" />
      <Value Name="PRODUCTENTERPRISEGN" Value="172" />
      <Value Name="PRODUCTSERVERRDSH" Value="175" />
      <Value Name="PRODUCTCLOUD" Value="178" />
      <Value Name="PRODUCTCLOUDN" Value="179" />
      <Value Name="PRODUCTHUBOS" Value="180" />
      <Value Name="PRODUCTONECOREUPDATEOS" Value="182" />
      <Value Name="PRODUCTCLOUDE" Value="183" />
      <Value Name="PRODUCTANDROMEDA" Value="184" />
      <Value Name="PRODUCTIOTOS" Value="185" />
      <Value Name="PRODUCTCLOUDEN" Value="186" />
    </Enum>
    <Enum EnumName="Win32_OperatingSystem.OSProductSuite" UnderlyingType="system.uint32" BitwiseFlags="true">
      <Value Name="SmallBusinessServer" Value="1" />
      <Value Name="Server2008Enterprise" Value="2" />
      <Value Name="BackOfficeComponents" Value="4" />
      <Value Name="CommunicationsServer" Value="8" />
      <Value Name="TerminalServices" Value="16" />
      <Value Name="SmallBusinessServerRestricted" Value="32" />
      <Value Name="WindowsEmbedded" Value="64" />
      <Value Name="DatacenterEdition" Value="128" />
      <Value Name="TerminalServicesSingleSession" Value="256" />
      <Value Name="HomeEdition" Value="512" />
      <Value Name="WebServerEdition" Value="1024" />
      <Value Name="StorageServerEdition" Value="8192" />
      <Value Name="ComputeClusterEdition" Value="16384" />
    </Enum>
    <Enum EnumName="Win32_OperatingSystem.OSType" UnderlyingType="system.uint16">
      <Value Name="Unknown" Value="0" />
      <Value Name="Other" Value="1" />
      <Value Name="MacOS" Value="2" />
      <Value Name="ATTUnix" Value="3" />
      <Value Name="DGUnix" Value="4" />
      <Value Name="DECNT" Value="5" />
      <Value Name="DigitalUnix" Value="6" />
      <Value Name="OpenVMS" Value="7" />
      <Value Name="HPUnix" Value="8" />
      <Value Name="AIX" Value="9" />
      <Value Name="MVS" Value="10" />
      <Value Name="OS400" Value="11" />
      <Value Name="OS2" Value="12" />
      <Value Name="JavaVM" Value="13" />
      <Value Name="MSDOS" Value="14" />
      <Value Name="Windows3x" Value="15" />
      <Value Name="Windows95" Value="16" />
      <Value Name="Windows98" Value="17" />
      <Value Name="WindowsNT" Value="18" />
      <Value Name="WindowsCE" Value="19" />
      <Value Name="NCR3000" Value="20" />
      <Value Name="NetWare" Value="21" />
      <Value Name="OSF" Value="22" />
      <Value Name="DCOS" Value="23" />
      <Value Name="ReliantUNIX" Value="24" />
      <Value Name="SCOUnixWare" Value="25" />
      <Value Name="SCOOpenServer" Value="26" />
      <Value Name="Sequent" Value="27" />
      <Value Name="IRIX" Value="28" />
      <Value Name="Solaris" Value="29" />
      <Value Name="SunOS" Value="30" />
      <Value Name="U6000" Value="31" />
      <Value Name="ASERIES" Value="32" />
      <Value Name="TandemNSK" Value="33" />
      <Value Name="TandemNT" Value="34" />
      <Value Name="BS2000" Value="35" />
      <Value Name="LINUX" Value="36" />
      <Value Name="Lynx" Value="37" />
      <Value Name="XENIX" Value="38" />
      <Value Name="VMESA" Value="39" />
      <Value Name="InteractiveUnix" Value="40" />
      <Value Name="BSDUnix" Value="41" />
      <Value Name="FreeBSD" Value="42" />
      <Value Name="NetBSD" Value="43" />
      <Value Name="GNUHurd" Value="44" />
      <Value Name="OS9" Value="45" />
      <Value Name="MACHKernel" Value="46" />
      <Value Name="Inferno" Value="47" />
      <Value Name="QNX" Value="48" />
      <Value Name="EPOC" Value="49" />
      <Value Name="IxWorks" Value="50" />
      <Value Name="VxWorks" Value="51" />
      <Value Name="MiNT" Value="52" />
      <Value Name="BeOS" Value="53" />
      <Value Name="HPMPE" Value="54" />
      <Value Name="NextStep" Value="55" />
      <Value Name="PalmPilot" Value="56" />
      <Value Name="Rhapsody" Value="57" />
      <Value Name="Windows2000" Value="58" />
      <Value Name="Dedicated" Value="59" />
      <Value Name="OS390" Value="60" />
      <Value Name="VSE" Value="61" />
      <Value Name="TPF" Value="62" />
    </Enum>
    <Enum EnumName="Win32_OperatingSystem.ProductType" UnderlyingType="system.uint32">
      <Value Name="Workstation" Value="1" />
      <Value Name="DomainController" Value="2" />
      <Value Name="Server" Value="3" />
    </Enum>
    <Enum EnumName="Win32_OperatingSystem.SuiteMask" UnderlyingType="system.uint32" BitwiseFlags="true">
      <Value Name="SmallBusinessServer" Value="1" />
      <Value Name="Server2008Enterprise" Value="2" />
      <Value Name="BackOfficeComponents" Value="4" />
      <Value Name="CommunicationsServer" Value="8" />
      <Value Name="TerminalServices" Value="16" />
      <Value Name="SmallBusinessServerRestricted" Value="32" />
      <Value Name="WindowsEmbedded" Value="64" />
      <Value Name="DatacenterEdition" Value="128" />
      <Value Name="TerminalServicesSingleSession" Value="256" />
      <Value Name="HomeEdition" Value="512" />
      <Value Name="WebServerEdition" Value="1024" />
      <Value Name="StorageServerEdition" Value="8192" />
      <Value Name="ComputeClusterEdition" Value="16384" />
    </Enum>
  </Enums>
</PowerShellMetadata>
'@ | Set-Content -LiteralPath $cdxmlPath -Encoding UTF8

$folder = "c:\wmi\Win32_OperatingSystem"
$typesPath = Join-Path -Path $folder -ChildPath "Win32_OperatingSystem.Types.ps1xml"

# create folder if not present:
$exists = Test-Path -Path $folder
if (!$exists) { $null = New-Item -Path $folder -ItemType Directory }

# write file
$content = @'
<?xml version="1.0" encoding="utf-8"?>


<!--
This file is licensed under 'Attribution 4.0 International' license (https://creativecommons.org/licenses/by/4.0/).

You can free of charge use this code in commercial and non-commercial code, and you can freely modify and adjust the code 
as long as you give appropriate credit to the original author Dr. Tobias Weltner.

This material was published and is maintained here: 

https://powershell.one/wmi/root/cimv2/win32_operatingsystem#typesps1xml-file
-->


<Types>
  <Type>
    <!--@

            Applicable type. This type is produced by Get-CimInstance. 
            To extend instances produced by Get-WmiObject, change the type name to: 

            System.Management.ManagementObject#root/cimv2\Win32_OperatingSystem

        @-->
    <Name>Microsoft.Management.Infrastructure.CimInstance#Root/CIMV2/Win32_OperatingSystem</Name>
    <Members>
      <ScriptProperty>
        <Name>DataExecutionPrevention_SupportPolicy</Name>
        <!--casting raw content to a enum. This translates numeric values to friendly text while leaving the original property value untouched:-->
        <GetScriptBlock>[Microsoft.PowerShell.Cmdletization.GeneratedTypes.Win32_OperatingSystem.DataExecutionPrevention_SupportPolicy]($this.PSBase.CimInstanceProperties['DataExecutionPrevention_SupportPolicy'].Value)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>ForegroundApplicationBoost</Name>
        <!--casting raw content to a enum. This translates numeric values to friendly text while leaving the original property value untouched:-->
        <GetScriptBlock>[Microsoft.PowerShell.Cmdletization.GeneratedTypes.Win32_OperatingSystem.ForegroundApplicationBoost]($this.PSBase.CimInstanceProperties['ForegroundApplicationBoost'].Value)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>FreePhysicalMemory</Name>
        <!--overwriting ToString() method to provide formatted output while leaving the original property value untouched:-->
        <GetScriptBlock>($this.PSBase.CimInstanceProperties['FreePhysicalMemory'].Value) | Add-Member -MemberType ScriptMethod -Name ToString -Force -Value { "{0:n2} GB" -f ($this/1MB) } -PassThru</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>FreeSpaceInPagingFiles</Name>
        <!--overwriting ToString() method to provide formatted output while leaving the original property value untouched:-->
        <GetScriptBlock>($this.PSBase.CimInstanceProperties['FreeSpaceInPagingFiles'].Value) | Add-Member -MemberType ScriptMethod -Name ToString -Force -Value { "{0:n2} GB" -f ($this/1MB) } -PassThru</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>FreeVirtualMemory</Name>
        <!--overwriting ToString() method to provide formatted output while leaving the original property value untouched:-->
        <GetScriptBlock>($this.PSBase.CimInstanceProperties['FreeVirtualMemory'].Value) | Add-Member -MemberType ScriptMethod -Name ToString -Force -Value { "{0:n2} GB" -f ($this/1MB) } -PassThru</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>Locale</Name>
        <!--converting raw content to a better .NET type:-->
        <GetScriptBlock>[System.Globalization.CultureInfo][Convert]::ToInt32(($this.PSBase.CimInstanceProperties['Locale'].Value),16)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>MaxProcessMemorySize</Name>
        <!--overwriting ToString() method to provide formatted output while leaving the original property value untouched:-->
        <GetScriptBlock>($this.PSBase.CimInstanceProperties['MaxProcessMemorySize'].Value) | Add-Member -MemberType ScriptMethod -Name ToString -Force -Value { "{0:n2} GB" -f ($this/1MB) } -PassThru</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>OperatingSystemSKU</Name>
        <!--casting raw content to a enum. This translates numeric values to friendly text while leaving the original property value untouched:-->
        <GetScriptBlock>[Microsoft.PowerShell.Cmdletization.GeneratedTypes.Win32_OperatingSystem.OperatingSystemSKU]($this.PSBase.CimInstanceProperties['OperatingSystemSKU'].Value)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>OSLanguage</Name>
        <!--converting raw content to a better .NET type:-->
        <GetScriptBlock>[System.Globalization.CultureInfo][int]($this.PSBase.CimInstanceProperties['OSLanguage'].Value)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>OSProductSuite</Name>
        <!--casting raw content to a flags enum. This translates bitmask to friendly text while leaving the original property value untouched:-->
        <GetScriptBlock>[Microsoft.PowerShell.Cmdletization.GeneratedTypes.Win32_OperatingSystem.OSProductSuite]($this.PSBase.CimInstanceProperties['OSProductSuite'].Value)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>OSType</Name>
        <!--casting raw content to a enum. This translates numeric values to friendly text while leaving the original property value untouched:-->
        <GetScriptBlock>[Microsoft.PowerShell.Cmdletization.GeneratedTypes.Win32_OperatingSystem.OSType]($this.PSBase.CimInstanceProperties['OSType'].Value)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>ProductType</Name>
        <!--casting raw content to a enum. This translates numeric values to friendly text while leaving the original property value untouched:-->
        <GetScriptBlock>[Microsoft.PowerShell.Cmdletization.GeneratedTypes.Win32_OperatingSystem.ProductType]($this.PSBase.CimInstanceProperties['ProductType'].Value)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>SizeStoredInPagingFiles</Name>
        <!--overwriting ToString() method to provide formatted output while leaving the original property value untouched:-->
        <GetScriptBlock>($this.PSBase.CimInstanceProperties['SizeStoredInPagingFiles'].Value) | Add-Member -MemberType ScriptMethod -Name ToString -Force -Value { "{0:n2} GB" -f ($this/1MB) } -PassThru</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>SuiteMask</Name>
        <!--casting raw content to a flags enum. This translates bitmask to friendly text while leaving the original property value untouched:-->
        <GetScriptBlock>[Microsoft.PowerShell.Cmdletization.GeneratedTypes.Win32_OperatingSystem.SuiteMask]($this.PSBase.CimInstanceProperties['SuiteMask'].Value)</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>TotalSwapSpaceSize</Name>
        <!--overwriting ToString() method to provide formatted output while leaving the original property value untouched:-->
        <GetScriptBlock>($this.PSBase.CimInstanceProperties['TotalSwapSpaceSize'].Value) | Add-Member -MemberType ScriptMethod -Name ToString -Force -Value { "{0:n2} GB" -f ($this/1MB) } -PassThru</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>TotalVirtualMemorySize</Name>
        <!--overwriting ToString() method to provide formatted output while leaving the original property value untouched:-->
        <GetScriptBlock>($this.PSBase.CimInstanceProperties['TotalVirtualMemorySize'].Value) | Add-Member -MemberType ScriptMethod -Name ToString -Force -Value { "{0:n2} GB" -f ($this/1MB) } -PassThru</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>TotalVisibleMemorySize</Name>
        <!--overwriting ToString() method to provide formatted output while leaving the original property value untouched:-->
        <GetScriptBlock>($this.PSBase.CimInstanceProperties['TotalVisibleMemorySize'].Value) | Add-Member -MemberType ScriptMethod -Name ToString -Force -Value { "{0:n2} GB" -f ($this/1MB) } -PassThru</GetScriptBlock>
      </ScriptProperty>
      <ScriptProperty>
        <Name>Version</Name>
        <!--converting raw content to a better .NET type:-->
        <GetScriptBlock>[Version]($this.PSBase.CimInstanceProperties['Version'].Value)</GetScriptBlock>
      </ScriptProperty>
    </Members>
  </Type>
</Types>
'@ | Set-Content -LiteralPath $typesPath -Encoding UTF8
return
#endregion

# see: https://powershell.one/wmi/root/cimv2/win32_operatingsystem#cdxml-definition

# import module
Import-Module -Name $cdxmlPath -Force -Verbose

# list new cmdlets
Get-Command -Module "Win32_OperatingSystem"

# native:
Get-CimInstance -ClassName Win32_OperatingSystem
Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property *

# cdxml:
Get-WmiOperatingSystem
Get-WmiOperatingSystem | Select-Object -Property Free*, OSType, *Size*, DataExecutionPrevention_SupportPolicy, ForegroundApplicationBoost, SuiteMask

# import type definition
Update-TypeData -PrependPath $typesPath
