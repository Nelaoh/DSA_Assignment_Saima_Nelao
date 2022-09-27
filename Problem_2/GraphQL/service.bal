import ballerina/graphql;
import ballerina/http;

listener http:Listener I = new (6000);
listener http:Listener httpListener = check new (6000);

public type CovidEntry record {|
    readonly string Date;
    string Region;
    decimal Deaths;
    decimal Confirmed_Cases;
    decimal Recoveries;
    decimal Tested;
|};

table<CovidEntry> key(Date) covidEntriesTable = table [
    {Date: "12/9/2021", Region: "Khomas", Deaths: 39, Confirmed_Cases: 465, Recoveries: 67, Tested: 1200}
];

public distinct service class CovidData {
    private final readonly & CovidEntry entryRecord;

    isolated function init(CovidEntry entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    isolated resource function get Date() returns string {
        return self.entryRecord.Date;
    }

    isolated resource function get Region() returns string {
        return self.entryRecord.Region;
    }

    isolated resource function get Deaths() returns decimal? {
        if self.entryRecord.Deaths is decimal {
            return self.entryRecord.Deaths / 1000;
        }
    }
    isolated resource function  get Confirmed_Cases() returns decimal? {
        if self.entryRecord.Confirmed_Cases is decimal {
            return self.entryRecord.Confirmed_Cases / 1000;
        }
    }

    isolated resource function get Recoveries() returns decimal? {
        if self.entryRecord.Recoveries is decimal {
            return self.entryRecord.Recoveries / 1000;
        }
    }

    isolated resource function get Tested() returns decimal? {
        if self.entryRecord.Tested is decimal {
            return self.entryRecord.Tested / 1000;
        }
    }

}
 function init() returns error? {
       
    }
isolated service /covid19 on new graphql:Listener(6000) {
    resource function get all() returns CovidData[] | error {
        CovidEntry[] covidEntries = covidEntriesTable.toArray().cloneReadOnly();
        return covidEntries.map(entry => new CovidData(entry));
    }


    // resource function get filter(string Date) returns CovidData? {
    //     CovidEntry? covidEntry = covidEntriesTable[Date];
    //     if covidEntry is CovidEntry {
    //         return new (covidEntry);
    //     }
    //     return covidEntry;
    // }

    // remote function add(CovidEntry entry) returns CovidData {
    //     covidEntriesTable.add(entry);
    //     return new CovidData(entry);
    // }
}

