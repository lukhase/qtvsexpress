param (
    [string]$dialogname = $( Read-Host "Name of new Dialog" ),
    [string]$project = "YourProject"
)

<#
The MIT License (MIT)


Copyright (c) 2014 Lukas Haselsteiner


Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:


The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>
 
 
Set-StrictMode -Version Latest

$projectFile = "$project.vcxproj";
$filtersFile = "$project.vcxproj.filters";

$dialogDir = "Qt";
$generatedFilesDir = ".\GeneratedFiles";

$debugConfs = @( "Debug Unicode|Win32" );
$dirsDebugConfs = @( "Debug Unicode" );
$debugGeneratedFilesFilters = @( "Generated Files\Debug" );

$releaseConfs = @( "Release Unicode|Win32" );
$dirsReleaseConfs = @( "Release Unicode" );
$releaseGeneratedFilesFilters = @( "Generated Files\Release" );

$generatedFilesHeaderFilter = "Generated Files";
$sourceFilesFilter = "Qt\Source Files";
$headerFilesFilter = "Qt\Header Files";
$formFilesFilter = "Qt\Forms";

$qtDialogUiTemplate = "..\Templates\QtDialogTemplate.ui";
$qtDialogHppTemplate = "..\Templates\QtDialogTemplate.h";
$qtDialogCppTemplate = "..\Templates\QtDialogTemplate.cpp";


$allConfs = $debugConfs + $releaseConfs;
$allDirsConfs = $dirsDebugConfs + $dirsReleaseConfs;
$allGeneratedFilesFilters = $debugGeneratedFilesFilters + $releaseGeneratedFilesFilters;

if (Test-Path "$dialogDir\$dialogName.ui") {
    Write-Output "$dialogDir\$dialogName.ui already exists"
    Exit
}
if (Test-Path "$dialogDir\$dialogname.h") {
    Write-Output "$dialogDir\$dialogname.h already exists"
    Exit
}
if (Test-Path "$dialogDir\$dialogname.cpp") {
    Write-Output "$dialogDir\$dialogname.cpp already exists"
    Exit
}

$template = Get-Content -Raw $qtDialogUiTemplate;
$file = $template -replace "TEMPLATE_DIALOG_NAME", $dialogname;
Set-Content "$dialogDir\$dialogName.ui" $file;

$template = Get-Content -Raw $qtDialogHppTemplate;
$file = $template -replace "TEMPLATE_DIALOG_NAME", $dialogname;
Set-Content "$dialogDir\$dialogname.h" $file;

$template = Get-Content -Raw $qtDialogCppTemplate;
$file = $template -replace "TEMPLATE_DIALOG_NAME", $dialogname;
Set-Content "$dialogDir\$dialogname.cpp" $file;


Function AddUiCustomBuild($nBuildNode, $conf)
{
    $n = $xml.CreateElement('Command', $xml.DocumentElement.NamespaceURI);
    $n.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + "$conf'");
    $n.InnerText = '"$(QTDIR)\bin\uic.exe" -o "' + $generatedFilesDir + '\ui_%(Filename).h" "%(FullPath)"';
    $nBuild.AppendChild($n)| out-null;

    $n = $xml.CreateElement('Message', $xml.DocumentElement.NamespaceURI);
    $n.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + "$conf'");
    $n.InnerText = 'Uic%27ing %(Identity)...';
    $nBuild.AppendChild($n)| out-null;

    $n = $xml.CreateElement('Outputs', $xml.DocumentElement.NamespaceURI);
    $n.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + "$conf'");
    $n.InnerText = $generatedFilesDir + '\ui_%(Filename).h;%(Outputs)';
    $nBuild.AppendChild($n)| out-null;

    $n = $xml.CreateElement('AdditionalInputs', $xml.DocumentElement.NamespaceURI);
    $n.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + "$conf'");
    $n.InnerText = '$(QTDIR)\bin\uic.exe;%(AdditionalInputs)';
    $nBuild.AppendChild($n)| out-null;
}

Function AddHeaderCustomBuild($nBuildNode, $conf, $isDebug)
{
    $n = $xml.CreateElement('Command', $xml.DocumentElement.NamespaceURI);
    $n.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + "$conf'");
	if ($isDebug) {
		$n.InnerText = '"$(QTDIR)\bin\moc.exe" "%(FullPath)" -o "' + $generatedFilesDir + '\$(ConfigurationName)\moc_%(Filename).cpp"  -DUNICODE -DWIN32 -DWIN64 -DQT_DLL -DQT_CORE_LIB -DQT_GUI_LIB -DQT_WIDGETS_LIB "-I.\GeneratedFiles" "-I." "-I$(QTDIR)\include" "-I.\GeneratedFiles\$(ConfigurationName)\." "-I$(QTDIR)\include\QtCore" "-I$(QTDIR)\include\QtGui" "-I$(QTDIR)\include\QtWidgets"';
	}
	else {
		$n.InnerText = '"$(QTDIR)\bin\moc.exe" "%(FullPath)" -o "' + $generatedFilesDir + '\$(ConfigurationName)\moc_%(Filename).cpp"  -DUNICODE -DWIN32 -DWIN64 -DQT_DLL -DQT_NO_DEBUG -DNDEBUG -DQT_CORE_LIB -DQT_GUI_LIB -DQT_WIDGETS_LIB "-I.\GeneratedFiles" "-I." "-I$(QTDIR)\include" "-I.\GeneratedFiles\$(ConfigurationName)\." "-I$(QTDIR)\include\QtCore" "-I$(QTDIR)\include\QtGui" "-I$(QTDIR)\include\QtWidgets"'; 
	}
    $nBuild.AppendChild($n)| out-null;

    $n = $xml.CreateElement('Message', $xml.DocumentElement.NamespaceURI);
    $n.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + "$conf'");
    $n.InnerText = 'Moc%27ing %(Identity) $(ConfigurationName)';
    $nBuild.AppendChild($n)| out-null;

    $n = $xml.CreateElement('Outputs', $xml.DocumentElement.NamespaceURI);
    $n.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + "$conf'");
    $n.InnerText = $generatedFilesDir + '\$(ConfigurationName)\moc_%(Filename).cpp';
    $nBuild.AppendChild($n)| out-null;

    $n = $xml.CreateElement('AdditionalInputs', $xml.DocumentElement.NamespaceURI);
    $n.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + "$conf'");
    $n.InnerText = '$(QTDIR)\bin\moc.exe;%(FullPath)';
    $nBuild.AppendChild($n)| out-null;
}


[xml]$xml = Get-Content $projectFile;
$nProj = $xml.GetElementsByTagName("Project")[0];
$grps = $nProj.GetElementsByTagName("ItemGroup");
$lastGroup = $grps[$grps.Count - 1];

$newGroup = $xml.CreateElement('ItemGroup', $xml.DocumentElement.NamespaceURI);

$nBuild = $xml.CreateElement('CustomBuild', $xml.DocumentElement.NamespaceURI);
$nBuild.SetAttribute("Include", "$dialogDir\$dialogname.ui");
$n = $xml.CreateElement('FileType', $xml.DocumentElement.NamespaceURI);
$n.InnerText = "Document";
$nBuild.AppendChild($n) | out-null;
$debugConfs | foreach { AddUiCustomBuild $nBuild $_ }
$releaseConfs | foreach { AddUiCustomBuild $nBuild $_ }
$newGroup.AppendChild($nBuild)| out-null;

$nBuild = $xml.CreateElement('CustomBuild', $xml.DocumentElement.NamespaceURI);
$nBuild.SetAttribute("Include", "$dialogDir\$dialogname.h");
$debugConfs | foreach { AddHeaderCustomBuild $nBuild $_ $TRUE }
$releaseConfs | foreach { AddHeaderCustomBuild $nBuild $_ $FALSE }
$newGroup.AppendChild($nBuild)| out-null;

$nClInclude = $xml.CreateElement('ClInclude', $xml.DocumentElement.NamespaceURI);
$nClInclude.SetAttribute("Include", "$generatedFilesDir\ui_$dialogname.h");
$newGroup.AppendChild($nClInclude)| out-null;

for ($i=0; $i -lt $allConfs.length; $i++) {
    $nClCompile = $xml.CreateElement('ClCompile', $xml.DocumentElement.NamespaceURI);
    $nClCompile.SetAttribute("Include", "$generatedFilesDir\" + $allDirsConfs[$i] + "\moc_$dialogname.cpp");
    for ($j=0; $j -lt $allConfs.length; $j++) {
        if ($j -ne $i) {
            $nExclude = $xml.CreateElement('ExcludedFromBuild', $xml.DocumentElement.NamespaceURI);
            $nExclude.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + $allConfs[$j] + "'");
            $nExclude.InnerText = "true";
            $nClCompile.AppendChild($nExclude)| out-null;
        }
    }
    $nPreHeader = $xml.CreateElement('PrecompiledHeader', $xml.DocumentElement.NamespaceURI);
    $nPreHeader.SetAttribute("Condition", "'" + '$(Configuration)|$(Platform)' + "'=='" + $allConfs[$i] + "'");
    $nPreHeader.InnerText = "NotUsing";
    $nClCompile.AppendChild($nPreHeader)| out-null;

    $newGroup.AppendChild($nClCompile)| out-null;
}

$nClCompile = $xml.CreateElement('ClCompile', $xml.DocumentElement.NamespaceURI);
$nClCompile.SetAttribute("Include", "$dialogDir\$dialogname.cpp");
$newGroup.AppendChild($nClCompile) | out-null;


$nProj.InsertAfter($newGroup,$lastGroup)| out-null;

$p = (Get-Location).Path + "\$projectFile";
$xml.Save($p);

[xml]$xml = Get-Content $filtersFile;
$nProj = $xml.GetElementsByTagName("Project")[0];
$grps = $nProj.GetElementsByTagName("ItemGroup");
$lastGroup = $grps[$grps.Count - 1];

$newGroup = $xml.CreateElement('ItemGroup', $xml.DocumentElement.NamespaceURI);

for ($i=0; $i -lt $allDirsConfs.length; $i++) {
    $nClCompile = $xml.CreateElement('ClCompile', $xml.DocumentElement.NamespaceURI);
    $nClCompile.SetAttribute("Include", "$generatedFilesDir\" + $allDirsConfs[$i] + "\moc_$dialogname.cpp");
    $nFilter = $xml.CreateElement('Filter', $xml.DocumentElement.NamespaceURI);
    $nFilter.InnerText = $allGeneratedFilesFilters[$i];
    $nClCompile.AppendChild($nFilter)| out-null;
    $newGroup.AppendChild($nClCompile)| out-null;
}

$nClInclude = $xml.CreateElement('ClInclude', $xml.DocumentElement.NamespaceURI);
$nClInclude.SetAttribute("Include", "$generatedFilesDir\ui_$dialogname.h");
$nFilter = $xml.CreateElement('Filter', $xml.DocumentElement.NamespaceURI);
$nFilter.InnerText = $generatedFilesHeaderFilter;
$nClInclude.AppendChild($nFilter)| out-null;
$newGroup.AppendChild($nClInclude)| out-null;


$nClCompile = $xml.CreateElement('ClCompile', $xml.DocumentElement.NamespaceURI);
$nClCompile.SetAttribute("Include", "$dialogDir\$dialogname.cpp");
$nFilter = $xml.CreateElement('Filter', $xml.DocumentElement.NamespaceURI);
$nFilter.InnerText = $sourceFilesFilter;
$nClCompile.AppendChild($nFilter)| out-null;
$newGroup.AppendChild($nClCompile)| out-null;

$nBuild = $xml.CreateElement('CustomBuild', $xml.DocumentElement.NamespaceURI);
$nBuild.SetAttribute("Include", "$dialogDir\$dialogname.h");
$nFilter = $xml.CreateElement('Filter', $xml.DocumentElement.NamespaceURI);
$nFilter.InnerText = $headerFilesFilter;
$nBuild.AppendChild($nFilter)| out-null;
$newGroup.AppendChild($nBuild)| out-null;

$nBuild = $xml.CreateElement('CustomBuild', $xml.DocumentElement.NamespaceURI);
$nBuild.SetAttribute("Include", "$dialogDir\$dialogname.ui");
$nFilter = $xml.CreateElement('Filter', $xml.DocumentElement.NamespaceURI);
$nFilter.InnerText = $formFilesFilter;
$nBuild.AppendChild($nFilter)| out-null;
$newGroup.AppendChild($nBuild)| out-null;

$nProj.InsertAfter($newGroup,$lastGroup)| out-null;

$p = (Get-Location).Path + "\$filtersFile";
$xml.Save($p);
