package importCsv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class ImportCsv {
	
	private static final String url = "jdbc:mysql://localhost:3306/crc?autoReconnect=true&useSSL=false";
	private static final String user = "root";
	private static final String password = "6978147098";
	
	public static void main(String args[]) 
    {
		loadCsvIntoDb();
    }
	
	 private static void loadCsvIntoDb()

	    {
	        try (Connection connection = DriverManager.getConnection(url, user, password))
	        {
	                String loadQuery = "LOAD DATA LOCAL INFILE '" + "/home/gvogias/Desktop/Assignment_1_Customers.csv" + "' INTO TABLE crc.customer FIELDS TERMINATED BY ','" + " LINES TERMINATED BY '\n' (idcustomer,custfirstname,custlastname,email,SSN,phone,state_abbrev,state_name,country) ";
	                System.out.println(loadQuery);
	                Statement stmt = connection.createStatement();
	                stmt.execute(loadQuery);
	                connection.close();
	        }
	        catch (Exception e)
	        {
	                e.printStackTrace();
	        }
	        
	    }

}
