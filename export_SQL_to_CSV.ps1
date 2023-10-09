##################
##  Input Data  ##
##################
$SQLServer = "server"  
$SQLDBName = "database"   
$CSV_Name = "csv_filename"
$CSV_Path = "C:\DV"
$delimiter = ";"

#################
##  SQL Query  ##
#################

#$SqlQuery = Get-Content -Path C:\DV\new.sql -Raw

$SqlQuery = "SELECT * FROM Person"

########################################################
##  After this point, please do not modify anything!  ##
########################################################
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection  
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName;  trusted_connection = true"  #Integrated Security = true;
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand  

$SqlCmd.Connection = $SqlConnection  
$SqlCmd.CommandText = $SqlQuery  
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter  
$SqlAdapter.SelectCommand = $SqlCmd

#Concatenate Filepath
$Export_Name = $CSV_Name + ".csv"
$PathToSave = $CSV_Path + '\'+ $Export_Name


#Creating Dataset
$DataSet = New-Object System.Data.DataSet  
$SqlAdapter.Fill($DataSet)
$DataSet.Tables.Count
try{
    if(!(Test-Path -Path $PathToSave)){
        New-Item -ItemType Directory -Force -Path $CSV_Path
    }
    $DataSet.Tables[0] | export-csv -Path $PathToSave -NoTypeInformation -Delimiter $delimiter
}catch{
    throw "Error!"
}

#Closes Connection
$SqlConnection.Close()

#$DataSet.Tables[0] | export-csv -Path $PathToSave -NoTypeInformation -Delimiter $delimiter
