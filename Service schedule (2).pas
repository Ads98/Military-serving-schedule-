PROGRAM MiltaryserviceSchedule;
   USES
      CRT, SYSUTILS,DOS;
         TYPE
            CalanderArray=ARRAY[1..8, 1..372] OF STRING;
            StaffArray=ARRAY[1..5] OF STRING;
            WorkIdArray=ARRAY[1..10]OF STRING;
            AuthIdarray=ARRAY[1..7]OF STRING;
            DayNameArray=ARRAY[0..6]OF STRING;

           StaffRec=RECORD
                       StaffIDcode                 :  STRING[5];
                       Rank                        :  STRING[15];
                       Forename                    :  STRING[15];
                       Surname                     :  STRING[20];
                       Jobfeild                    :  STRING[15];
                       Username                    :  STRING[15];
                       Password                    :  STRING[10];
                       Schedule                    :  CalanderArray;
                    END;



            Jobrec=RECORD
                      Jobtitle                     :   STRING[30];
                      jobID                        :   STRING[5];
                      Jobdescribtion               :   STRING[75];
                      Whenhowfound                 :   STRING[20];
                      AuthId                       :   AuthIdArray;
                      StaffCount                   :   LONGINT;
                      Priority                     :   LONGINT;
                   END;

            AircMiltarytrec=RECORD
                           AircMiltarytID              :   STRING[3];
                           CallSign                :   STRING[15];
                           AircMiltarytStatus          :   STRING[20];
                           Flighthours             :   LONGINT;
                           Flight_timefromservice  :   LONGINT;
                        END;

            Authorisationcodes=RECORD
                                  AuthirisationId   : STRING[3];
                                  Description       : STRING[20];
                               END;

            StaffAuthorisations=RECORD
                                   StaffauthID     :  STRING[7];
                                   StaffId         :  STRING[7];
                                   AuthorisationID :  STRING[7];
                                END;
            Workcodes=RECORD
                         ComponentId               :  STRING[7];
                         Description               :  STRING[20];
                         Completion                :  BOOLEAN;
                      END;

            WorkJobRec=RECORD
                           ComponentID             : WorkIdArray;
                           JobID                   : STRING[7];
                           JobWorkID               : STRING[7];
                        END;

            AircMiltarytJobRec=RECORD
                               AircMiltarytjobId       :  LONGINT;
                               JobID               :  STRING[5];
                               AircMiltarytID          :  STRING[3];
                               complete            :  BOOLEAN;
                            END;
            TaskIdRec=RECORD
                         LastId:LONGINT;
                      END;

            StaffFileType                     = FILE OF StaffRec;
            JobFiletype                       = FILE OF JobRec;
            AircMiltarytFiletype                  = FILE OF AircMiltarytRec;
            Authorisationcodesfiletype        = FILE OF Authorisationcodes;
            Staffauthorisationsfiletype       = FILE OF Staffauthorisations;
            WorkcodesFiletype                 = FILE OF Workcodes;
            WorkjobFiletype                   = FILE OF WorkJobRec;
            JetJobRecfiletype                 = FILE OF AircMiltarytJobRec;
            TaskFiletype                      = FILE OF TaskIdRec;
       VAR
           StaffFile, StaffBackup            :  StaffFiletype;
           JobFile ,JobBackUp                :  JobFiletype;
           AIrcMiltarytFile,AircMiltarytBackup       :  AircMiltarytFiletype;
           AuthFile ,AuthBackup              :  AuthorisationcodesFiletype;
           StaffAuthsFile, StaffAuthBackup   :  Staffauthorisationsfiletype;
           Workfile,WorkBackup               :  WorkcodesFiletype;
           Workjobfile,WorkJobBackup         :  WorkJobFiletype;
           AircMiltarytJobfile,JetJobBackup      :  JetJobRecFiletype;
           TaskIdFIle,TaskBackup             :  TaskFiletype;

           Staff,NewRecStaff  :  Staffrec;
           Job,NewRecJob      :  JobRec;
           Jet,NewRecJet      :  AircMiltarytRec;
           Auth               :  Authorisationcodes;
           Staffauths         :  StaffAuthorisations;
           Work               :  Workcodes;
           WorkJob            :  WorkJobRec;
           JetJob             :  AircMiltarytJobRec;
           NewId              :  TaskIdRec;
           POS,Row,Col        :  LONGINT;
           StaffRecNo         :  LONGINT;
           Entrey             :  STRING[15];
           Choice             :  CHAR;
           AnotherSearch      :  CHAR;
           Drive              :  CHAR;
           Located            :  BOOLEAN;
           Searchname         :  STRING[15];
           SearchId           :  STRING[7];
           Found              :  BOOLEAN;
           OPTIONS            :  CHAR;
           Schedule           :  CalanderArray;
           StaffID            :  StaffArray;


     PROCEDURE Delay(Year,Month,Day,Number:LONGINT);
        VAR
           Subtract,JobDay,Today,IntialRow,IntialCol,TodayYear,TodayMonth,TodayDay,TodayNo,Time,AircMiltarytPostion,CurrentJobId,Add:LONGINT;
           Free,Present,Complete:BOOLEAN;
           Finished:CHAR;
        BEGIN
           CASE Number OF
              0:Subtract:=0;
              1:Subtract:=0;
              2:Subtract:=1;
              3:Subtract:=2;
              4:Subtract:=3;
              5:Subtract:=4;
              6:Subtract:=5;
           END;
           CASE Number OF
              0:Add:=1;
              6:Add:=2;
              ELSE
              Add:=0;
           END;
           BEGIN
              Complete:=FALSE;
              Free:=FALSE;
              Found:=FALSE;
              Present:=FALSE;
              ToDay:=(Month-1)*31+Day+Add;
              JobDay:=(Month-1)*31 +Day- Subtract;
              WITH Staff DO
              BEGIN
                 REPEAT
                    ROW:=0;
                    BEGIN
                       REPEAT
                          Row:=Row+1;
                          IF (Schedule[Row,JobDay] <>'-1') AND (JobDay<ToDay) THEN
                             BEGIN
                                Present:=TRUE;
                             END;
                       UNTIL (Present) OR (Row=8);
                    END;
                    IF (NOT(Present)) AND (Jobday<>Today) THEN
                    BEGIN
                       JobDay:=JobDay+1;
                    END;
                 UNTIL (Present) OR (Jobday=Today);
                 IF Present=TRUE THEN
                 BEGIN
                    IntialRow:=Row;
                    CurrentJobID:=STRTOINT(Schedule[Row,JobDay]);
                    RESET(AircMiltarytJobFile);
                    REPEAT
                       READ(AircMiltarytJobFile,JetJob);
                       IF (Jetjob.AircMiltarytJObID=CurrentJobId) AND (Jetjob.Complete=FALSE) THEN
                       Found:=TRUE;
                    UNTIL (Found) OR (EOF(AircMiltarytJobFile));
                    IF Found THEN
                    BEGIN
                       AircMiltarytPostion:=FILEPOS(AircMiltarytJobFile)-1;
                       BEGIN
                          RESET(AircMiltarytFile);
                          REPEAT
                             READ(AircMiltarytFile,Jet);
                          UNTIL Jet.AircMiltarytId=JetJob.AircMiltarytId;
                       END;
                       BEGIN
                          RESET(JobFile);
                          REPEAT
                             READ(JobFile,Job);
                          UNTIL Job.jobid=JetJob.JobId;
                       END;
                       BEGIN
                          WITH Jet DO
                          BEGIN
                             WRITELN('This job  has not yet been complete');
                             WRITELN;
                             WRITELN('Job title: ',Job.Jobtitle);
                             WRITELN('JobId: ',Job.Jobid);
                             WRITELN('Job description: ', job.Jobdescribtion);
                             WRITELN('AircMiltaryt Id: ',AircMiltarytId);
                             WRITELN('Call sign: ',CallSign);
                             WRITELN('Status: ',AircMiltarytStatus);
                             WRITELN('Flight Hours: ',FlightHours);
                             WRITELN('Time since last service: ',Flight_TimeFromservice);
                             IF JetJob.Complete=FALSE THEN
                             WRITELN('Progress: Incomplete');
                             WRITELN;
                          END;
                          REPEAT
                             WRITELN('This job is marked as incomplete do you wish to re-schedule or has the job been completed');
                             WRITELN;
                             WRITELN('Y= Mark as complete,N= Re-Schedule');
                             Finished:=UPCASE(READKEY);
                             IF (Finished <>'Y') AND (Finished <>'N') THEN
                             WRITELN('Invalid input please try again');
                          UNTIL(Finished='Y') OR (Finished='N');
                          IF Finished='Y' THEN
                          BEGIN
                             SEEK(AircMiltarytJobFile,AircMiltarytPostion);
                             JetJob.Complete:=TRUE;
                             WRITE(AircMiltarytJobFile,JetJob);
                             SEEK(AIRCMiltaryTJOBFILE,AIRCMiltaryTPOSTION);
                             READ(AircMiltarytJobFile,jetjob);
                          END;
                          IF Finished='N' THEN
                          BEGIN
                             REPEAT
                                Time:=1;
                                BEGIN
                                   REPEAT
                                      BEGIN
                                         IF Schedule[Time,ToDay]='-1' THEN
                                         Free:=TRUE
                                         ELSE
                                         Time:=Time+1;
                                      END;
                                   UNTIL(Free=TRUE) OR (Time=8);
                                   IF Free=TRUE THEN
                                   BEGIN
                                      SEEK(StaffFile,StaffRecNo);
                                      READ(StaffFile,STaff);
                                      Schedule[Time,ToDay]:=INTTOSTR(CurrentJobId);
                                      Schedule[IntialRow,JobDay]:='-1';
                                      WRITE(StaffFile,Staff);

                                   END;
                                END;
                                IF Free=FALSE THEN
                                ToDay:=ToDay+1;
                             UNTIL Free=TRUE;
                          END;
                       END;
                    END;
                 END;
              END;
           END;
        END;

     FUNCTION WeekDay: DayNameArray ;
        VAR
           DayName:DayNameArray;
           Pos:LONGINT;
        BEGIN
           WeekDay[0]:='Sunday';
           WeekDay[1]:='Monday';
           WeekDay[2]:='Tuesday';
           WeekDay[3]:='Wendsday';
           WeekDay[4]:='Thursday';
           WeekDay[5]:='Friday';
           WeekDay[6]:='Saturday';
        END;

     PROCEDURE ShowDate;
        VAR
           TodayYear, TodayMonth,TodayDay,TodayNo,Times, StaffJobRecNo, Day,Add,Count,TaskID: LONGINT;
           MatchId,JobMatch,Plane:STRING[5];
           Found:BOOLEAN;
           DayName:DayNameArray;
        BEGIN
           DayName:=WeekDay;
           CLRSCR;
           GETDATE(TodayYear,TodayMonth,TodayDay,TodayNo);
           SEEK(StaffFile,StaffRecNo);
           READ(StaffFile,Staff);
           Delay(TodayYEar,TodayMOnth,TodayDay,TodayNo);
           BEGIN
              GOTOXY(35,2);
              BEGIN
                 CLRSCR;
                 GOTOXY(35,2);
                 WRITELN('Weekley roster');
                 READKEY;
                 WRITELN;
                 WRITELN('Today''Date is: ',TodayDay,'/',TodayMonth,'/',TodayYear);
                 WRITELN('Press any key to continue');
                 READKEY;
                 WRITELN;
                 CASE TodayNo OF
                    0:Add:=1;
                    6:Add:=2;
                    ELSE
                    Add:=0;
                 END;
              END;
              Col:=(TodayMonth-1) *31 +TodayDay+Add;
              IF (TodayNo=0) OR (TodayNo=6) THEN
              TodayNo:=1;
              CLRSCR;
              FOR Times:=Col TO COL+(5-TodayNo) DO
              BEGIN
                 CASE TodayNo OF
                    1:WRITELN('Monday');
                    2:WRITELN('Tuesday');
                    3:WRITELN('Wendsday');
                    4:WRITELN('Thursday');
                    5:WRITELN('Friday');
                 END;
                 Count:=0;
                 TodayNo:=TodayNo+1;
                 FOR Row:= 1 TO 8 DO
                 BEGIN
                    CASE Row OF
                       1:WRITELN('8:00');
                       2:WRITELN('10:00');
                       3:WRITELN('12:00');
                       4:WRITELN('14:00');
                       5:WRITELN('16:00');
                       6:WRITELN('18:00');
                       7:WRITELN('20:00');
                       8:WRITELN('22:00');
                    END;
                    Located:=FALSE;
                    IF Staff.Schedule[Row,TIMES] <>'-1' THEN
                    Located:=TRUE;
                    BEGIN
                       IF Located=TRUE THEN
                       BEGIN
                          TaskId:=STRTOINT(Staff.Schedule[Row,Times]);
                          Count:=Count+1;
                          RESET(AircMiltarytJobFile);
                          REPEAT
                             READ(AircMiltarytJobFile,JetJob);
                          UNTIL Jetjob.AircMiltarytJobId=TaskID;
                          MatchId:=JetJob.JobId;
                          Plane:=Jetjob.AircMiltarytId;
                          RESET(JobFile);
                          REPEAT
                             READ(JobFile,Job);
                          UNTIL Job.jobId=MatchID;
                          BEGIN
                             WITH Job DO
                             BEGIN
                                WRITELN;
                                WRITELN('JobId: ',JobId);
                                WRITELN('Job title: ',JobTitle);
                                WRITELN('Job description: ',JobDescribtion);
                                WRITELN('How the fault was deected: ',WhenHowFound);
                                WRITELN;
                                RESET(AircMiltarytJobFile);
                                Found:=FALSE;
                                REPEAT
                                   READ(AircMiltarytJobFile,JetJob);
                                   IF (Jetjob.complete=FALSE) AND (JobId=Jetjob.jobId) THEN
                                   Found:=TRUE;
                                UNTIL(Found) OR(EOF(AircMiltarytJobFile));
                                RESET(AircMiltarytFile);
                                REPEAT
                                    READ(AircMiltarytFile,Jet);
                                UNTIL(Jet.AircMiltarytid=Plane) OR (EOF(AircMiltarytFile));
                                WITH Jet DO
                                BEGIN
                                   WRITELN('AircMiltaryt');
                                   WRITELN;
                                   WRITELN('AircMiltaryt Id: ',AircMiltarytid);
                                   WRITELN('Call sign: ',CallSign);
                                   WRITELN('Total Flight hours: ',FlightHours);
                                   WRITELN('Flight hours since last service: ',Flight_timefromservice);
                                END;
                                WRITELN('Press any key to continue');
                                READKEY;
                                WRITELN;
                             END;
                          END;
                       END;
                    END;
                    IF Located=FALSE THEN
                    BEGIN
                       WRITELN('You have no jobs at this time');
                    END;
                 END;
                 IF Count=0 THEN
                 WRITELN;
                 WRITELN('You have no jobs on this day');
                 WRITELN;
                 WRITELN('Press anykey to continue');
                 READKEY;
                 WRITELN;
              END;
           END;
        END;

    PROCEDURE DisplayRecord;
        BEGIN
           WITH Staff DO
           BEGIN
              CLRSCR;
              WRITELN('Here is your personal information');
              WRITELN;
              WRITELN('ID code: ',StaffIdcode);
              WRITELN('Name: ',Forename,' ', Surname);
              WRITELN('Job feild: ',Jobfeild);
              WRITELN('Press anykey to continue');
              READKEY;
           END;
        END;

    PROCEDURE ViewFile;
       VAR
          FileChoice:CHAR;
          RecordNo:LONGINT;
          Authentrey:STRING[7];
       BEGIN
          REPEAT
             CLRSCR;
             WRITELN('Press A to view the staff file');
             WRITELN('Press B to view the aircMiltaryt file');
          //   WRITELN('Press C to view the calander file');
             WRITELN('Press x to exit');
             Filechoice :=UPCASE(READKEY);
             CASE Filechoice OF
               'A': BEGIN
                       SEEK(StaffFile,StaffRecNo);
                       READ(StaffFile,Staff);
                       IF Staff.Rank='Flight Sergant'THEN
                       BEGIN
                          RESET(StaffFile);
                          WHILE NOT EOF(StaffFile) DO
                          BEGIN
                             READ(StaffFile,Staff);
                             WITH Staff DO
                             BEGIN
                                IF StaffIDcode <>'-1' THEN
                                BEGIN
                                   WRITELN;
                                   WRITELN('ID code: ',StaffIdcode);
                                   WRITELN('Name: ',Forename,' ', Surname);
                                   WRITELN('Job feild: ',Jobfeild);
                                   WRITELN('Rank: ',Rank);
                                   WRITELN('Press anykey to continue');
                                   READKEY;
                                END;
                             END;
                          END;
                       END;
                       SEEK(StaffFile,StaffRecNo);
                       READ(StaffFile,Staff);
                       IF Staff.Rank <> 'Flight Sergant' THEN
                       BEGIN
                          WITH Staff DO
                          BEGIN
                             WRITELN;
                             WRITELN('ID code: ',StaffIdcode);
                             WRITELN('Name: ',Forename,' ', Surname);
                             WRITELN('Job feild: ',Jobfeild);
                             WRITELN('Press anykey to continue');
                             READKEY;
                          END;
                       END;

                    END;

               'B':BEGIN
                      RESET(AircMiltarytFile);
                      WHILE NOT EOF(AircMiltarytFile) DO
                      BEGIN
                         READ(AircMiltarytFile,Jet);
                         WITH JET DO
                         BEGIN
                            IF AircMiltarytId <> '-1' THEN
                            BEGIN
                               WRITELN;
                               WRITELN('AircMiltaryt ID: ',AircMiltarytId);
                               WRITELN('Call sign: ',CallSign);
                               WRITELN('AircMiltaryt Status: ',AircMiltarytStatus);
                               WRITELN('Flight hours since last service: ',Flight_timefromservice);
                               WRITELN('Total flight time (Hours): ',Flighthours);
                               WRITELN('Press anykey to continue');
                               READKEY;
                            END;
                         END;
                      END;
                   END;
               'C':WRITELN('To be added');
               'X':WRITELN;
               ELSE
               WRITELN('Invalid input please select from the list provided');
               WRITELN('Press anykey to continue');
               READKEY;
             END;
          UNTIL Filechoice='X';
      END;

   PROCEDURE Search(SearchItem:CHAR);
      VAR
         AuthRecNo:LONGINT;
         StaffAuthRecNo:LONGINT;
         AuthIdentfier:STRING[5];
         AnotherSearch,AuthChoice,ViewList,UserOption:CHAR;
         DisplayMessage:STRING[2];
      BEGIN
         DisplayMessage:='-1';
         REPEAT
            IF (SearchItem <>'A') AND (SearchItem<>'B') THEN
            BEGIN
               CLRSCR;
               WRITELN('Please select one of the following options');
               WRITELN;
               WRITELN('Press A to search for a member of staff');
               WRITELN('Press B to search for a aircMiltaryt');
               WRITELN('Press x to exit');
               SearchItem:=UPCASE(READKEY);
            END;
            CASE SearchItem OF
               'A': BEGIN
                       WITH Staff DO
                       REPEAT
                          CLRSCR;
                          RESET(StaffFile);
                          WRITELN('Please enter the surname of the desired staff member');
                          READLN(SearchName);
                          Located:=FALSE;
                          REPEAT
                             READ(StaffFile,Staff);
                             IF UPPERCASE(SearchName) = UPPERCASE(Surname) THEN
                             Located:=TRUE;
                          UNTIL (Located) OR (EOF(StaffFile));
                          BEGIN
                             WRITELN;
                             WRITELN('ID code: ',StaffIdcode);
                             WRITELN('Name: ',Forename,' ', Surname);
                          END;
                          IF Located=FALSE THEN
                          BEGIN
                             REPEAT
                                CLRSCR;
                                WRITELN('No matches found do you wish to reenter the desired name');
                                WRITELN('Y: YES');
                                WRITELN('N: NO');
                                Choice:=UPCASE(READKEY);
                                CASE Choice OF
                                   'Y':WRITELN;
                                   'N':WRITELN;
                                   ELSE
                                   BEGIN
                                      WRITELN;
                                      WRITELN('Invalid input please try again');
                                      WRITELN;
                                      WRITELN('Press any key to continue');
                                      READKEY;
                                   END;
                                END;
                             UNTIL (Choice='Y') OR(Choice='N');
                          END;
                       UNTIL (Located) OR (Choice='N');
                       IF Choice <> 'N' THEN
                       BEGIN
                          REPEAT
                             WRITELN('Please enter the Id number of the staff member you require');
                             READLN(SearchId);
                             Found:=FALSE;
                             IF SearchID =Staff.StaffIdCode THEN
                             Found:=TRUE;
                             BEGIN
                                IF Found=FALSE THEN
                                BEGIN
                                   REPEAT
                                      CLRSCR;
                                      WRITELN('The code you entered was invalid do you wish to try again');
                                      WRITELN('Press Y for yes');
                                      WRITELN('Press N for no');
                                      UserOption:=UPCASE(READKEY);
                                      IF (UserOption<>'Y') AND (UserOption<>'N') THEN
                                      BEGIN
                                         WRITELN;
                                         WRITELN('Invalid input please try again');
                                         WRITELN;
                                         WRITELN('Press any key to continue');
                                         READKEY;
                                         CLRSCR;
                                      END;
                                   UNTIL(UserOption='Y') OR (UserOption='N');
                                END;
                             END;
                              CLRSCR;
                              WITH Staff DO
                              IF UserOption<>'N' THEN
                              BEGIN
                                 WRITELN;
                                 WRITELN('ID code: ',StaffIdcode);
                                 WRITELN('Name: ',Forename,' ', Surname);
                              END;
                          UNTIL (UserOption='N') OR (Found);
                          IF Found=TRUE THEN
                          BEGIN
                             RESET(StaffFile);
                             REPEAT
                                READ(StaffFile,Staff);
                             UNTIL Staff.StaffIdCode=SearchID;
                             WITH Staff DO
                             BEGIN
                                WRITELN;
                                WRITELN('ID code: ',StaffIdcode);
                                WRITELN('Name: ',Forename,' ', Surname);
                                WRITELN('Job feild: ',Jobfeild);
                                WRITELN('Press anykey to continue');
                                READKEY;
                                WRITELN;
                                REPEAT
                                   WRITELN('Do you wish to view the authirsations for this member of staff(Y=Yes,N=No)');
                                   AuthChoice:=UPCASE(READKEY);
                                   IF (AuthChoice<>'Y') AND (AuthChoice<>'N') THEN
                                   BEGIN
                                      WRITELN('Invalid input please try again');
                                      WRITELN;
                                      WRITELN('Press anykey to continue');
                                      READKEY;
                                   END;
                                UNTIL (AuthChoice='Y') OR (AuthChoice='N');
                                IF AuthChoice='Y' THEN
                                BEGIN
                                   WRITELN('Authirisations');
                                   BEGIN
                                      RESET(StaffAuthsFile);
                                      StaffAuthRecNo:=1;
                                      WHILE NOT EOF(StaffAUthsFile) DO
                                      BEGIN
                                         REPEAT
                                            Found:=FALSE;
                                            SEEK(StaffAuthsFile,StaffAuthRecNo);
                                            READ(StaffAuthsFile,StaffAuths);
                                            IF StaffAuths.StaffID=Staff.StaffIdCode THEN
                                            Found:=TRUE;
                                            StaffAuthRecNo:=StaffAuthRecNo+1;
                                            IF Found=TRUE THEN
                                            BEGIN
                                               AuthIdentfier:=StaffAuths.AuthorisationID;
                                               RESET(AuthFile);
                                               WHILE NOT EOF(AuthFile) DO
                                               BEGIN
                                                  REPEAT
                                                     READ(AuthFile,Auth);
                                                     IF Authidentfier=Auth.AuthirisationId THEN
                                                     BEGIN
                                                        WRITELN;
                                                        WRITELN('Authirisation: ',Auth.Description);
                                                        WRITELN('Press anykey to continue');
                                                        READKEY;
                                                     END;
                                                  UNTIL (AuthIdentfier=Auth.AuthirisationId) OR (EOF(AuthFile));
                                               END;
                                           END;
                                         UNTIL (Found) OR (EOF(StaffAUthsFile));
                                      END;
                                   END;
                                END;
                             END;
                          END;
                       END;
                    END;
               'B':BEGIN
                      REPEAT
                         CLRSCR;
                         RESET(AircMiltarytFile);
                         REPEAT
                            WRITELN('Do you wish to view the list of current aircMiltaryt (Y=Yes,N=No)');
                            ViewList:=UPCASE(READKEY);
                            IF (ViewList<>'Y') AND (ViewList<>'N') THEN
                            BEGIN
                               WRITELN('Error invalid input please try again');
                               WRITELN;
                               WRITELN('Press any key to continue');
                               READKEY;
                               WRITELN;
                            END;
                         UNTIL (ViewList='Y') OR (ViewList='N');
                         IF ViewLIst='Y' THEN
                         BEGIN
                            WHILE NOT EOF(AircMiltarytFile) DO
                            BEGIN
                               READ(AircMiltarytFile,Jet);
                               WITH Jet DO
                               BEGIN
                                  IF AircMiltarytId<>'-1' THEN
                                  BEGIN
                                     WRITELN;
                                     WRITELN('AircMiltaryt Id: ',AircMiltarytId);
                                     WRITELN('Call sign: ', Callsign);
                                     WRITELN('AircMiltaryt status: ',AircMiltarytStatus);
                                     WRITELN;
                                     WRITELN('Press anykey to continue');
                                     READKEY;
                                  END;
                               END;
                            END;
                         END;
                         WRITELN;
                         WRITELN('Please enter the Id number of the desired aircMiltaryt');
                         READLN(SearchName);
                         Located:=FALSE;
                         RESET(AircMiltarytFile);
                         BEGIN
                            REPEAT
                               READ(AircMiltarytFile,Jet);
                               IF UPPERCASE(Jet.AircMiltarytId) = UPPERCASE(SearchName) THEN
                               Located:=TRUE;
                            UNTIL (Located) OR (EOF(AircMiltarytFile));

                            BEGIN
                               IF Located=FALSE THEN
                               BEGIN
                                  REPEAT
                                     WRITELN('Invalid input do you wish to search again? (Y=Yes, N=No)');
                                     Options:=UPCASE(READKEY);
                                     IF Options ='Y' THEN
                                     WRITELN;
                                     IF (Options <>'Y') AND (Options<>'N') THEN
                                     WRITELN('Invalid input please try again');
                                  UNTIL (Options='Y') OR (Options='N');
                               END;
                            END;

                            BEGIN
                               IF Located=TRUE THEN
                               WITH Jet DO
                               BEGIN
                                  WRITELN;
                                  WRITELN('AircMiltarytId:',AircMiltarytId);
                                  WRITELN('CallSign: ',Callsign);
                                  WRITELN('AircMiltaryt status: ',AircMiltarytStatus);
                                  WRITELN('Flight hours since last service: ',Flight_timefromservice);
                                  WRITELN('Total Flight time: ',Flighthours);
                                  WRITELN;
                                  WRITELN('Press anykey to continue');
                                  READKEY;
                               END;
                            END;
                         END;
                      UNTIL (Located) OR (Options='N');
                   END;
               'X':WRITELN;
               ELSE
               BEGIN
                  WRITELN('Invalid input please try again');
                  WRITELN;
                  WRITELN('Press anykey to continue');
                  READKEY;
                  WRITELN;
               END;
            END;
            BEGIN
               REPEAT
                  WRITELN('Do You wish to search for another Record (Y=Yes, N=No)');
                  AnotherSearch:=UPCASE(READKEY);
                  IF (AnotherSearch <>'Y') AND (AnotherSearch <>'N') THEN
                  WRITELN('Invalid input please try again');
               UNTIL(AnotherSearch='Y') OR (AnotherSearch='N');
            END;
         UNTIL (Choice='X') OR (AnotherSearch='N');;
      END;

    {FUNCTION AssignPriority (CurrentJobCode,NewJobCode:STRING;AircMiltarytPos:LONGINT):LONGINT;
       BEGIN
          RESET(JobFile);
          REPEAT
             READ(JobFile,Job);
          UNTIL Job.JobID=NewJobCode;
          SEEK(AircMiltarytFile,AircMiltarytPos);
          READ(AircMiltarytFile,Jet);
          BEGIN
             RESET(JobFile);
             REPEAT
                READ(JobFile,Job);
             UNTIL Job.JobId=CurrentJobCode;
          WITH Jet DO
          BEGIN
             IF AircMiltarytStatus='Job in progress' THEN}


    FUNCTION RoleTest (JobCode:STRING):STRING;
       BEGIN
          IF JobCode='A0001' THEN
          RoleTest:='Mechanics';
          IF JobCode='A0002' THEN
          RoleTest:='Mechanics';
          IF JobCode='A0003' THEN
          RoleTest:='Mechanics';
          IF JobCode='A0004' THEN
          RoleTest:='Mechanics';
          IF JobCode='A0005' THEN
          RoleTest:='Avionics';
          IF JobCode='A0006' THEN
          RoleTest:='Mechanics';
          IF JobCode='A0007' THEN
          RoleTest:='Mechanics';
          IF JobCode='A0008' THEN
          RoleTest:='WeaponsTechnican';
       END;

    FUNCTION RoleCheck(StaffId,Role:STRING):BOOLEAN;
       BEGIN
          RoleCheck:=FALSE;
          WITH Staff DO
          BEGIN
             RESET(StaffFile);
             REPEAT
                READ(StaffFile,Staff);
             UNTIL StaffIdCode=StaffId;
             IF JobFeild=Role THEN
             RoleCheck:=TRUE;
          END;
       END;

    FUNCTION RankTest(MemberRank:STRING):LONGINT;
       BEGIN
          IF MemberRank='SAC' THEN
          RankTest:=1;
          IF MemberRank='Corporal' THEN
          RankTest:=2;
          IF MemberRank='Sergant' THEN
          Ranktest:=3;
          IF memberRank='Flight Sergant' THEN
          RankTest:=4;
       END;

    FUNCTION Jobtest(Jobnumber:STRING):LONGINT;
       BEGIN
          IF JobNumber='A0001' THEN
          JobTest:=2;
          IF JobNumber='A0002' THEN
          JobTest:=5;
          IF JobNumber='A0003' THEN
          JobTest:=3;
          IF JobNumber='A0004' THEN
          JobTest:=2;
          IF JobNumber='A0005' THEN
          JobTest:=1;
          IF JobNumber='A0006' THEN
          JobTest:=4;
          IF JobNumber='A0007' THEN
          JobTest:=3;
          IF JobNumber='A0008' THEN
          JobTest:=4;
       END;

    FUNCTION MemberTest(JobStaff:StaffArray;JobValue:LONGINT;JobCode:STRING):BOOLEAN;
       VAR
          Pos,Count,TotalCount,RankValue:LONGINT;
          Valid,SergantTest,StaffRequirment:BOOLEAN;
       BEGIN
          Membertest:=FALSE;
          TotalCount:=0;
          Count:=0;
          Valid:=False;
          SergantTest:=TRUE;
          Pos:=0;
//          WITH Staff DO
//          BEGIN
             FOR POS:=1 TO 5 DO
             BEGIN
//WRITELN('pos ',pos,' jobstaff[pos] ',jobstaff[pos]);
             IF JobStaff[Pos]<> '-1' THEN
             BEGIN
                TotalCount:=TotalCount+1;
                RESET(StaffFile);
                REPEAT
                   READ(StaffFile,Staff);
                UNTIL Staff.StaffIdCode=JobStaff[Pos];
//WRITELN('FOUND');
                RankValue:=RankTest(Staff.Rank);
//writeln('RANK VALUE ',RANKVALUE);
                IF RankValue>=2 THEN
                Count:=Count+1;
                IF JobCode='A00002' THEN
                BEGIN
                   IF RankValue<3 THEN
                   SergantTest:=FALSE
                   ELSE
                   SergantTest:=TRUE;
                END;
//WRITELN('count ',count,' totalcount ',totalcount,' jobvalue ',jobvalue);

                StaffRequirment:= (Count>=1) AND (TotalCount>=JobValue);

//WRITELN('staffreq ok');
                MemberTest := (StaffRequirment=TRUE) AND(SergantTest=TRUE);
//WRITELN('membertest ok');
             END;
             END;
//          END;
//WRITELN('end of function');
//READKEY;
       END;

    FUNCTION AuthTest(JobCode,MemberId:STRING):BOOLEAN;
       VAR
          MatchCount,AuthCount:LONGINT;
       BEGIN
          AuthTest:=FALSE;
          Found:=FALSE;
          AuthCount:=0;
          matchCount:=0;
          RESET(JobFile);
          REPEAT
              READ(JobFile,Job);
          UNTIL Job.JobId=JobCode;
          BEGIN
             REPEAT
                AuthCount:=AuthCount+1;
                RESET(StaffAuthsFile);
                REPEAT
                   READ(StaffAuthsFile,StaffAuths);
                   IF (StaffAuths.StaffId=memberId) AND (StaffAuths.AuthorisationID=Job.AuthId[AuthCount]) THEN
                   Found:=TRUE;
                   IF Found =TRUE THEN
                   MatchCount:=MatchCount+1;
                UNTIL (Found) OR EOF(StaffAuthsFile);
             UNTIL Job.AuthID[AuthCount+1]='-1';
             IF MatchCount=AuthCount THEN
             AuthTest:=TRUE;
          END;
       END;

   FUNCTION DaysOfMonth(Month:LONGINT):LONGINT;
      BEGIN
         IF Month=1 THEN
         DaysOfMonth:=31;
         IF Month=2 THEN
         DaysOfMonth:=28;
         IF Month=3 THEN
         DaysOfMonth:=31;
         IF Month=4 THEN
         DaysOfMonth:=30;
          IF Month=5 THEN
         DaysOfMonth:=31;
         IF Month=6 THEN
         DaysOfMonth:=30;
          IF Month=7 THEN
         DaysOfMonth:=31;
         IF Month=8 THEN
         DaysOfMonth:=31;
          IF Month=9 THEN
         DaysOfMonth:=30;
         IF Month=10 THEN
         DaysOfMonth:=31;
          IF Month=11 THEN
         DaysOfMonth:=30;
         IF Month=12 THEN
         DaysOfMonth:=31;
      END;

   FUNCTION TodayNumber(JobDate:LONGINT):LONGINT;
      VAR
         Add,Today,Count,Differance,TodayYear,TodayMonth,TodayDay,TodayNo:LONGINT;
         Valid:BOOLEAN;
      BEGIN
         GETDATE(TodayYear ,TodayMonth ,TodayDay,TodayNo);
         Today:=(TodayMonth-1) *31 +TodayDay;
         Differance:=JobDate-Today;
         Count:=0;
         IF  Differance >0 THEN
         BEGIN
            REPEAT
               TodayNo:=TodayNo+1;
               IF TodayNo>6 THEN
               BEGIN
                  TodayNo:=0;
               END;
               Count:=Count+1;
            UNTIL (Count=Differance) OR ( Differance=0);
         END;
         TodayNumber:=TodayNo;
      END;
   FUNCTION SelectMonth(Date:LONGINT):LONGINT;
      VAR
         Select:CHAR;
      BEGIN
         IF (Date >= 29) AND (Date<>31) THEN
         BEGIN
            REPEAT
               CLRSCR;
               WRITELN('Press A for January');
               WRITELN('Press B for March');
               WRITELN('Press C for April');
               WRITELN('Press D for May');
               WRITELN('Press E for june');
               WRITELN('Press F for July');
               WRITELN('Press G for August');
               WRITELN('Press H For September');
               WRITELN('Press I for October');
               WRITELN('Press J for november');
               WRITELN('Press K for December');
               Select:=UPCASE(READKEY);
               CASE Select OF
                  'A':SelectMonth:=1;
                  'B':SelectMonth:=3;
                  'C':SelectMonth:=4;
                  'D':SelectMonth:=5;
                  'E':SelectMonth:=6;
                  'F':SelectMonth:=7;
                  'G':SelectMonth:=8;
                  'H':SelectMonth:=9;
                  'I':SelectMonth:=10;
                  'J':SelectMonth:=11;
                  'K':SelectMonth:=12;
                  ELSE
                  WRITELN('Invalid input please try again');
                  WRITELN;
                  WRITELN('Press any key to continue');
                  READKEY;
               END;
            UNTIL (ORD(Select)>64) AND (ORD(Select)<75);
         END;
         BEGIN
            IF Date= 31 THEN
            BEGIN
               REPEAT
                  CLRSCR;
                  WRITELN('Press A for January');
                  WRITELN('Press B for March');
                  WRITELN('Press C for May');
                  WRITELN('Press D for July');
                  WRITELN('Press E for August');
                  WRITELN('Press F for October');
                  WRITELN('Press G for December');
                  Select:=UPCASE(READKEY);
                  CASE Select OF
                     'A':SelectMonth:=1;
                     'B':SelectMonth:=3;
                     'C':SelectMonth:=5;
                     'D':SelectMonth:=7;
                     'E':SelectMonth:=8;
                     'F':SelectMonth:=10;
                     'G':SelectMonth:=12;
                     ELSE
                     WRITELN('Invalid input please try again');
                     WRITELN;
                     WRITELN('Press any key to continue');
                     READKEY;
                  END;
               UNTIL (ORD(Select)>64) AND (ORD(Select)<70);
            END;
         END;
         BEGIN
            IF (Date >= 29) AND (Date<>31) THEN
            BEGIN
               REPEAT
                  CLRSCR;
                  WRITELN('Press A for January');
                  WRITELN('Press B for March');
                  WRITELN('Press C for April');
                  WRITELN('Press D for May');
                  WRITELN('Press E for june');
                  WRITELN('Press F for July');
                  WRITELN('Press G for August');
                  WRITELN('Press H For September');
                  WRITELN('Press I for October');
                  WRITELN('Press J for november');
                  WRITELN('Press K for December');
                  Select:=UPCASE(READKEY);
                  CASE Select OF
                     'A':SelectMonth:=1;
                     'B':SelectMonth:=3;
                     'C':SelectMonth:=4;
                     'D':SelectMonth:=5;
                     'E':SelectMonth:=6;
                     'F':SelectMonth:=7;
                     'G':SelectMonth:=8;
                     'H':SelectMonth:=9;
                     'I':SelectMonth:=10;
                     'J':SelectMonth:=11;
                     'K':SelectMonth:=12;
                     ELSE
                     WRITELN('Invalid input please try again');
                     WRITELN;
                     WRITELN('Press any key to continue');
                     READKEY;
                  END;
               UNTIL (ORD(Select)>64) AND (ORD(Select)<76);
            END;
         END;
         BEGIN
            IF (Date< 31) AND (Date<>29) AND (Date<>30) THEN
            BEGIN
               REPEAT
                  CLRSCR;
                  WRITELN('Press A for January');
                  WRITELN('Press B for Febuary');
                  WRITELN('Press C for March');
                  WRITELN('Press D for April');
                  WRITELN('Press E for May');
                  WRITELN('Press F for june');
                  WRITELN('Press G for July');
                  WRITELN('Press H for August');
                  WRITELN('Press I For September');
                  WRITELN('Press J for October');
                  WRITELN('Press K for November');
                  WRITELN('Press L for December');
                  Select:=UPCASE(READKEY);
                  CASE Select OF
                     'A':SelectMonth:=1;
                     'B':SelectMonth:=2;
                     'C':SelectMonth:=3;
                     'D':SelectMonth:=4;
                     'E':SelectMonth:=5;
                     'F':SelectMonth:=6;
                     'G':SelectMonth:=7;
                     'H':SelectMonth:=8;
                     'I':SelectMonth:=9;
                     'J':SelectMonth:=10;
                     'K':SelectMonth:=11;
                     'L':SelectMonth:=12;
                     ELSE
                    WRITELN('Invalid input please try again');
                    WRITELN;
                    WRITELN('Press any key to continue');
                    READKEY;
                  END;
               UNTIL (ORD(Select)>64) AND (ORD(Select)<77);
            END;
         END;
   END;

   FUNCTION SelectTime:LONGINT;
      VAR
         Entered:CHAR;
         Correct:BOOLEAN;
      BEGIN
         REPEAT
            Correct:=TRUE;
            CLRSCR;
            WRITELN('Press A for 8:00AM');
            WRITELN('Press B for 10:00AM');
            WRITELN('Press C for 12:00AM');
            WRITELN('Press D for 2:00PM');
            WRITELN('Press E for 4:00PM');
            WRITELN('Press F for 6:00PM');
            WRITELN('Press G for 8:00PM');
            Entered:=UPCASE(READKEY);
            CASE Entered OF
               'A':SelectTime:=8;
               'B':SelectTime:=10;
               'C':SelectTime:=12;
               'D':SelectTime:=14;
               'E':SelectTime:=16;
               'F':SelectTime:=18;
               'G':SelectTime:=20;
               ELSE
               Correct:=FALSE;
               IF correct=FALSE THEN
               BEGIN
                  WRITELN;
                  WRITELN('Invalid input please select from one of the options above');
                  WRITELN;
                  WRITELN('Press any key to continue');
                  READKEY;
               END;
            END;
         UNTIL Correct;
      END;

   FUNCTION GenerateId:LONGINT;
      VAR
         CurrentId:LONGINT;
      BEGIN
         RESET(TaskIdFile);
         READ(TaskIdFile,NewId);
         CurrentId:=NewID.LAstId;
         GenerateId:=NewId.LastId+1;
         NewId.LastId:=NewId.lastID+1;
         RESET(TaskIdFile);
         WRITE(TaskIdFile,NewId);
      END;

   PROCEDURE AddAuths;
      VAR
         SerachCriteria,AuthChoice,AddAgain:CHAR;
         AuthCode:STRING[10];
         AuthIdenification:STRING[3];
         Allowed:BOOLEAN;
      BEGIN
         REPEAT
            Allowed:=TRUE;
            SerachCriteria:='A';
            CLRSCR;
            WRITELN('Please select the member of staff that you wish to assign a authrisation');
            SeArch(SerachCriteria);
            BEGIN
            REPEAT
            CLRSCR;
            WRITELN('PLease slect the authrisation you wish to assign to the member of staff');
            WRITELN('Press A to assing  AircMiltaryt jack');
            WRITELN('Press B to assing Cockpit entry ');
            WRITELN('Press C to assing  Hydrolic systems');
            WRITELN('Press D to assing  Apply external power');
            WRITELN('Press E to assing  Hydrolic rig');
            WRITELN('Press F to assing  Engine ringe');
            WRITELN('Press G to assing Live weapons saftey');
            WRITELN('Press X to exit');
            Authchoice:=UPCASE(READKEY);
            WITH Auth DO
            CASE AuthChoice OF
               'A':AuthIdenification:='A2J';
               'B':AuthIdenification:='C2C';
               'C':AuthIdenification:='H2S';
               'D':AuthIdenification:='AEP';
               'E':AuthIdenification:='H2R';
               'F':AuthIdenification:='ENG';
               'G':AuthIdenification:='LWS';
               'x':WRITELN;
               ELSE
                Allowed:=FALSE;
                WRITELN;
                WRITELN('Invalid input please selectedone of the options within the menu');
                WRITELN;
                WRITELN('Press anykey to continue');
                READKEY;
            END;
            UNTIL Allowed=True;
            END;
            WITH StaffAuths DO
            IF AuthChoice<>'X' THEN
            BEGIN
               REPEAT
                  WRITELN('Please enter the given staff authrisation id');
                  READLN(AuthCode);
                  IF LENGTH(Authcode)<> 5 THEN
                  BEGIN
                     WRITELN('Invalid entry please re enter the assinged id code');
                     WRITELN;
                     WRITELN('press anykey to continue');
                     READKEY;
                     WRITELN;
                  END;
               UNTIL(LENGTH(AuthCode)=5);
               RESET(StaffAuthSFile);
               REPEAT
                  READ(StaffauthSFile,StaffAuths);
               UNTIL(StaffAuthId='-1') OR (EOF(StaffAuthsFile));
               StaffId:=Staff.StaffIdcode;
               AuthorisationID:=AuthIdenification;
               StaffAuthId:=AuthCode;
            END;
            WRITE(StaffAuthsFile,StaffAuths);
            BEGIN
               REPEAT
                  WRITELN('Do you wish to assign another authirsation (Y=yes,N=No)');
                  AddAgain:=UPCASE(READKEY);
                  IF (AddAgain<>'Y') AND (AddAgain<>'N') THEN
                  BEGIN
                     WRITELN('Error invalid input please try again');
                     WRITELN;
                     WRITELN('Press any key to continue');
                     READKEY;
                  END;
               UNTIL (AddAgain='Y') OR (AddAgain='N');
            END;
         UNTIL (AddAgain='N') OR (AuthChoice='X');
      END;

   FUNCTION EnterPassword:STRING;
      VAR
         PassChar,EntryChar:CHAR;
         Passphrase,Entry,Password1,Password2:STRING[15];
      BEGIN
         REPEAT
            BEGIN
               REPEAT
                  WRITELN('Please enter your password');
                  Passphrase:='';
                  REPEAT
                     Passchar:=READKEY;
                     IF ORD(Passchar) <> 13 THEN
                     BEGIN
                        Passphrase := Passphrase + passchar;
                        WRITE('*');
                     END;
                     BEGIN
                        IF ORD(Passchar) =8 THEN
                        BEGIN
                           Passphrase := COPY(Passphrase,1,LENGTH(Passphrase)-2);
                           GOTOXY(WHEREX-2,WHEREY);
                           WRITE('  ');
                           GOTOXY(WHEREX-2,WHEREY);
                        END;
                     END;
                  UNTIL ORD(Passchar) =13;
                  IF (LENGTH(Passphrase)>=5) AND (LENGTH(Passphrase)<=10) THEN
                  Password1:=Passphrase
                  ELSE
                  BEGIN
                     WRITELN;
                     WRITELN('A password must consist of between 5 to 10 charecters');
                     WRITELN;
                     WRITELN('Please re enter your password');
                     WRITELN;
                     WRITELN('Press any key to continue');
                     READKEY;
                  END;
               UNTIL(LENGTH(Passphrase)>=5) AND (LENGTH(Passphrase)<=10);
               BEGIN
                  REPEAT
                     WRITELN;
                     WRITELN('Please verify this password');
                     WRITELN;
                     WRITELN('Please enter your password here');
                     Entry:='';
                     REPEAT
                        EntryChar:=READKEY;
                        IF ORD(EntryChar) <> 13 THEN
                        BEGIN
                           Entry := Entry + EntryChar;
                           WRITE('*');
                        END;
                        BEGIN
                           IF ORD(EntryChar) =8 THEN
                           BEGIN
                              Passphrase := COPY(Entry,1,LENGTH(Entry)-2);
                              GOTOXY(WHEREX-2,WHEREY);
                              WRITE('  ');
                              GOTOXY(WHEREX-2,WHEREY);
                           END;
                        END;
                     UNTIL ORD(EntryChar) =13;
                     IF (LENGTH(Entry)>=5) AND (LENGTH(Entry)<=10) THEN
                     Password2:=Entry
                     ELSE
                     BEGIN
                        WRITELN;
                        WRITELN('A password must consist of between 5 to 10 charecters');
                        WRITELN;
                        WRITELN('Please re enter your password');
                        WRITELN;
                        WRITELN('Press any key to continue');
                        READKEY;
                     END;
                  UNTIL(LENGTH(Entry)>=5) AND (LENGTH(Entry)<=10);
                  IF Password1=Password2 THEN
                  EnterPassword:=Password1
                  ELSE
                  BEGIN
                     WRITELN;
                     WRITELN('Error the passwords do not match please re enter the desired password');
                     WRITELN;
                     WRITELN('Press any key to continue');
                     READKEY;
                  END;
               END;
            END;
         UNTIL Password1=Password1;
      END;

   PROCEDURE CollectData;
      VAR
         Option:CHAR;
         JobSelection:CHAR;
         Entry,Passphrase:STRING[15];
         LargestId,JetId:STRING[5];
         Day:STRING[2];
         AnotherAdd,Find,AnotherSearch,Select,RankChoice,PassChar:CHAR;
         Weekday,Valid,Exit,Requirment,StaffTest,SearchAgain:BOOLEAN;
         NewId,StaffPostion,NewDay,MonthChoice,TodayNo,Count,MemberCount,Time,Sub,MembersAdded,Nostr,ErrCode,SelectedDay:LONGINT;
         NewtaskID:LONGINT;
         JobMember:StaffArray;
      BEGIN
         WRITELN('Please slect the file you wish to appened');
         WRITELN('Press A to appened the staff file');
         WRITELN('Press B to appened the AircMiltaryt file');
         WRITELN('Press C to appened the Job file');
         WRITELN('Press D to assign a new job to the calander');
         WRITELN('Press E to assign new authrisations');
         WRITELN('Press x to exit');
         Choice:=UPCASE(READKEY);
         CASE Choice Of
            'A': BEGIN
                    WITH NewRecStaff DO
                    BEGIN
                       CLRSCR;
                       REPEAT
                          WRITELN('Please enter your assinged Id code');
                          READLN(StaffIdcode);
                          IF (LENGTH(StaffIdcode)<>5) THEN
                          BEGIN
                             WRITELN('Invalid entry please re enter the assinged id code');
                             WRITELN;
                             WRITELN('press anykey to continue');
                             READKEY;
                             WRITELN;
                          END;
                       UNTIL (LENGTH(StaffIdcode)=5);
                       REPEAT
                          WRITELN('Please enter your forename');
                          READLN(Forename);
                          IF (LENGTH(Forename)>14)  OR (LENGTH(Forename)=0) THEN
                          BEGIN
                             WRITELN('Error there is an invalid amount of charecters within this name pleaase re enter your name or contact the system admisartor');
                             WRITELN;
                             WRITELN('Press anykey to continue');
                             READKEY;
                             WRITELN;
                          END;
                       UNTIL(LENGTH(Forename)<=15) AND (LENGTH(Forename)>0);
                       REPEAT
                          WRITELN('Please enter your surname');
                          READLN(Surname);
                          IF (LENGTH(Surname)>14)  OR (LENGTH(Surname)=0) THEN
                          BEGIN
                             WRITELN('Error there is an invalid amount of charecters within this name pleaase re enter your name or contact the system admisartor');
                             WRITELN;
                             WRITELN('Press anykey to continue');
                             READKEY;
                             WRITELN;
                          END;
                       UNTIL(LENGTH(Surname)<=15) AND (LENGTH(Surname)>0);
                       WRITELN('Please enter your rank');
                       BEGIN
                          REPEAT
                             CLRSCR;
                             WRITELN('Please select one of the following ranks');
                             WRITELN('Press 1 for SAC');
                             WRITELN('Press 2 for Corporal');
                             WRITELN('Press 3 for sergant');
                             WRITELN('Press 4 for flight Sergant');
                             RankChoice:=UPCASE(READKEY);
                             CASE RankChoice OF
                                '1':Rank:='SAC';
                                '2':Rank:='Corporal';
                                '3':Rank:='Sergant';
                                '4':Rank:='Flight Sergant';
                                ELSE
                                WRITELN('Invalid input please try agian');
                                WRITELN;
                                WRITELN('Press anykey to continue');
                                READKEY;
                             END;
                          UNTIL (ORD(RankChoice) <53) AND (ORD(RankChoice) >48);
                       END;
                       REPEAT
                          WRITELN('Please select your job role');
                          WRITELN('1:Avionics');
                          WRITELN('2:Mechainc');
                          WRITELN('3 Weapons technican');
                          Option:=UPCASE(READKEY);
                          CASE Option OF
                             '1':JobFeild:='Avionics';
                             '2':JobFeild:='Mechanics';
                             '3':Jobfeild:='Weapons technican';
                             ELSE
                             WRITELN('Invalid input please try agian');
                             WRITELN;
                             WRITELN('Press amy key to continue');
                             READKEY;
                          END;
                       UNTIL (ORD(Option) > 48) AND (ORD(OPTION) <52);
                       REPEAT
                          WRITELN('Please enter Your username below');
                          READLN(Entry);
                           WRITELN('Error there is an ivalid amount of charecters within the user name please re enter your username');
                           WRITELN;
                           WRITELN('Press any key to continue');
                           READKEY;
                           WRITELN;
                          IF (LENGTH(Entry)=0) OR (LENGTH(Entry)>17) THEN
                          BEGIN
                             WRITELN('Error there is an ivalid amount of charecters within the user name please re enter your username');
                             WRITELN;
                             WRITELN('Press any key to continue');
                             READKEY;
                             WRITELN;
                          END;
                       UNTIL(LENGTH(Entry)>0)AND (LENGTH(Entry)<=25);
                       UserName:=UPPERCASE(Entry);
                       WRITELN;
                       Password:=Enterpassword;
                       WRITELN;
                       FOR Row:=1 TO 8 DO
                       FOR Col:=1 TO 372 DO
                       Schedule[Row,Col]:='-1';
                    END;
                 END;
            'B':BEGIN
                   WITH NewRecJet DO
                   BEGIN
                      REPEAT
                         WRITELN('Pleasse enter the provided aircMiltaryt Id');
                         READLN(AircMiltarytId);
                         IF LENGTH(AircMiltarytId)<>4  THEN
                         BEGIN
                            WRITELN('Error you have entered an invalid Id');
                            WRITELN;
                            WRITELN('Please re enter the aircaftId');
                            WRITELN;
                            WRITELN('Press any key to continue');
                            READKEY;
                            WRITELN;
                         END;
                      UNTIL LENGTH(AircMiltarytId)=3;
                      REPEAT
                         WRITELN('Please enter the provided call sign');
                         READLN(Callsign);
                          IF (LENGTH(Callsign)=0) OR (LENGTH(Callsign)>14) THEN
                         BEGIN
                            WRITELN('Error you have entered an invalid amoubt of charecters');
                            WRITELN;
                            WRITELN('Please re enter the aircaft call-sign');
                            WRITELN;
                            WRITELN('Press any key to continue');
                            READKEY;
                            WRITELN;
                         END;
                      UNTIL (LENGTH(CallSign)>0) AND (LENGTH(CallSign)<=15);
                      REPEAT
                         CLRSCR;
                         WRITELN('Please assign the suitable aircMiltaryt status');
                         WRITELN;
                         WRITELN('Please select one of the following options');
                         WRITELN('1:Serviable');
                         WRITELN('2:Job in progress');
                         WRITELN('3:Unservicable');
                         Option:=UPCASE(READKEY);
                         CASE Option OF
                            '1':AircMiltarytStatus:='=Servicable';
                            '2':AircMiltarytstatus:='Job in progress';
                            '3':AircMiltarytstatus:='Unservicable';
                            ELSE
                            BEGIN
                               WRITELN('Invalid input please try again');
                               WRITELN;
                               WRITELN('Press anykey to continue');
                               READKEY;
                            END;
                         END;
                      UNTIL (ORD(Option) > 48) AND (ORD(OPTION) <52);
                   END;
                END;
            'C':BEGIN
                   WITH NewrecJob DO
                   BEGIN
                      WRITELN('Please enter the given job Id');
                      READLN(JobId);
                      WRITELN('Please enter the Job title');
                      READLN(JobTitle);
                      WRITELN('Please enter how the fault was identfied');
                      READLN(WhenhowFound);
                   END;
                END;
            'D':BEGIN
                   WRITELN('Please select the aircMiltaryt that needs servecing');
                   WRITELN;
                   WRITELN('Press anykey to continue');
                   Find:='B';
                   Search(Find);
                   JetId:=Jet.AircMiltarytId;
                   REPEAT
                      CLRSCR;
                      WRITELN('Please select the job you wish to assign');
                      WRITELN('Press 1 to select wheel change');
                      WRITELN('Press 2 to select engine change');
                      WRITELN('Press 3 to select brake pad change');
                      WRITELN('Press 4 to select oil filter change');
                      WRITELN('Press 5 to select bulb change');
                      WRITELN('Press 6 to select flight control surface change');
                      WRITELN('Press 7 to select hydrolic actulator');
                      WRITELN('Press 8 to select role change');
                      JobSelection:=UPCASE(READKEY);
                      WITH Job DO
                      CASE JobSelection OF
                         '1':JobId:='A0001';
                         '2':JobId:='A0002';
                         '3':JobId:='A0003';
                         '4':JobId:='A0004';
                         '5':JobId:='A0005';
                         '6':JobId:='A0006';
                         '7':JobId:='A0007';
                         '8':JobId:='A0008';
                         ELSE
                         BEGIN
                            WRITELN('Invalid input please try again');
                            WRITELN;
                            WRITELN('Press anykey to continue');
                            READKEY;
                         END;
                      END;
                   UNTIL (ORD(JobSelection)>48) AND (ORD(JobSelection)<57);
                   BEGIN
                      MemberCount:=JobTest(Job.Jobid);
                      CLRSCR;
                      WRITELN;
                      BEGIN
                         FOR Sub:=1 TO 5 DO
                         JobMember[Sub]:='-1';
                      END;
                      BEGIN
                         REPEAT
                            POS:=0;
                            Count:=0;
                            MembersAdded:=0;
                            Exit:=FALSE;
                            Valid:=FALSE;
                            SearchAgain:=FALSE;
                            WRITELN('Please select each member of staff you wish to assign to the job');
                            BEGIN
                               WITH Staff DO
                               REPEAT
                                  BEGIN
                                     //REPEAT
                                        CLRSCR;
                                        RESET(StaffFile);
                                        WRITELN('You have added ',Count,' Out of ',MemberCount,'  ',MemberCount-count,' More members required');
                                        READKEY;
                                        WRITELN;
                                        WRITELN('curently assinged to the job');
                                        BEGIN
                                           FOR Sub:=1 TO 5 DO
                                           IF JobMember[Sub] <>'-1' THEN
                                           BEGIN
                                              MembersAdded:=MembersAdded+1;
                                              REPEAT
                                                 READ(StaffFile,Staff);
                                              UNTIL(StaffIdcode=Jobmember[Sub]) OR(EOF(StaffFile));
                                              IF StaffIdcode=Jobmember[Sub] THEN
                                              WRITE('ID Code: ',StaffIdcode,' Forenmae:',Forename,' Surname: ' ,Surname);
                                              WRITELN;
                                           END;
                                        END;
                                        IF MembersAdded=0 THEN
                                        WRITELN('No members have been added yet');
                                        WRITELN;
                                        Find:='A';
                                        Search(Find);

                                     Valid:=FALSE;
                                     Requirment:=FALSE;
                                     StaffPostion:=FILEPOS(StaffFile);
                                     IF AuthTest(Job.JobId,Staff.StaffIdCode)=TRUE THEN
                                     Valid:=TRUE;
                                     IF Valid=FALSE THEN
                                     BEGIN
                                        REPEAT
                                           WRITELN('This staff member is not qualified');
                                           WRITELN;
                                           WRITELN('Do you wish to serach for another member of staff (Y=Yes N=No)');
                                           AnotherSearch:=UPCASE(READKEY);
                                           IF (AnotherSearch<>'Y') AND (AnotherSearch<>'N') THEN
                                           BEGIN
                                              WRITELN;
                                              WRITELN('Invalid input please try again');
                                              WRITELN('Press any key to continue');
                                              READKEY;
                                           END;
                                        UNTIL(Anothersearch='Y') OR (AnotherSearch='N');
                                        IF AnotherSearch='Y' THEN
                                        SearchAgain:=TRUE;
                                     END;
                                  END;
                                  IF Valid=TRUE THEN
                                  BEGIN
                                     Pos:=Pos+1;
                                     Jobmember[Pos]:=StaffIdcode;
                                     Count:=Count+1;
                                  END;
                                  IF Count>=MemberCount THEN
                                  REPEAT
                                     WRITELN('Do you wish to add another member of staff?(Y=Yes,N=No)');
                                     Select:=UPCASE(READKEY);
                                     IF (Select<>'Y') AND (Select<>'N')  THEN
                                     BEGIN
                                        WRITELN('Invalid Input please try again');
                                        WRITELN;
                                        WRITELN('Press any key to continue');
                                        READKEY;
                                     END;
                                  UNTIL(Select='Y') OR (Select='N');
                                  IF (Count>=MemberCount) AND (Select='N') THEN
                                  Requirment:=TRUE;
                               UNTIL(SearchAgain=FALSE) AND (Requirment=TRUE);
                               StaffTest:=MemberTest(Jobmember,MemberCount,Job.JobId);
                               IF StaffTest=FALSE THEN
                               BEGIN
                                  WRITELN('The combanation of staff members is invalid plaese try again');
                                  WRITELN;
                                  WRITELN('Press any key to continue');
                                  READKEY;
                                  FOR Pos:=1 TO 5 DO
                                  JobMember[Pos]:='-1';
                               END;
                            END;
                         UNTIL(StaffTest=TRUE);
                         BEGIN
                            WeekDay:=TRUE;
                            REPEAT
                               CLRSCR;
                               WRITELN('Please select the date that the job will take place');
                               WRITELN;
                               REPEAT
                                  BEGIN
                                     WRITELN('Please enter the day of the month that the job will take place');
                                     READLN(Day);
                                     VAL(Day,NoStr,Errcode);
                                     IF Errcode<>0 THEN
                                     BEGIN
                                        WRITELN('Invalid input please enter an integar');
                                        WRITELN;
                                        WRITELN('Press any key to continue');
                                        READKEY;
                                        WRITELN;
                                     END;
                                     IF ErrCode=0 THEN
                                     BEGIN
                                        SelectedDay:=STRTOINT(Day);
                                        IF (SelectedDay>31) OR (Selectedday<=0) THEN
                                        BEGIN
                                           WRITELN('Invalid input the date entered must be smaller than the 31 and gretaer then 0');
                                           WRITELN;
                                           WRITELN('Press any key to continue');
                                           READKEY;
                                        END;
                                     END;
                                  END;
                               UNTIL (SelectedDay<=31) AND (SelectedDay>0) AND (ErrCode=0);
                               WRITELN;
                               WRITELN('Press any key to continue');
                               READKEY;
                               WRITELN;
                               WRITELN('Please select the month during which the job will take place');
                               WRITELN;
                               MonthChoice:=SelectMonth(SelectedDay);
                               Newday:=(MonthChoice-1) *31+SelectedDay;
                               ToDayNo:=Todaynumber(NewDay);
                               IF (TodayNo=6) OR (TodayNo=0) THEN
                               WeekDay:=FALSE
                               ELSE
                               Weekday:=TRUE;
                               IF WeekDay=FALSE THEN
                               BEGIN
                                  WRITELN('Invalid input a job can not be assinged on a weekend');
                                  WRITELN;
                                  WRITELN('Press any key to continue');
                                  READKEY;
                                  WRITELN('TodayNo: ',TodayNo);
                               END;
                            UNTIL WeekDay=TRUE;
                            BEGIN
                               WRITELN('Please enter The time at which the job will take place');
                               Time:=SelectTime;
                               IF Time=8 THEN
                               Row:=1;
                               IF Time=10 THEN
                               Row:=2;
                               IF Time=12 THEN
                               Row:=3;
                               IF Time=14 THEN
                               Row:=4;
                               IF Time=16 THEN
                               Row:=5;
                               IF Time=18 THEN
                               Row:=6;
                               IF Time=20 THEN
                               Row:=7;
                               IF Time=22 THEN
                               Row:=8;
                            END;
                            BEGIN
                               NewTaskID:=GenerateID ;
                               FOR Sub:= 1 TO 5 DO
                               IF JobMember[Sub]<>'-1' THEN
                               BEGIN
                                  RESET(StaffFile);
                                  REPEAT
                                     READ(StaffFile,Staff);
                                  UNTIL (Staff.StaffIdcode=Jobmember[Sub]);
                                  StaffPostion:=FILEPOS(StaffFile);
                                  SEEK(StaffFile,StaffPostion-1);
                                  Staff.Schedule[Row,NewDay]:=INTTOSTR(NewTaskID);
                                  WRITE(StaffFile,Staff);
                               END;
                            END;
                            BEGIN
                               RESET(AircMiltarytJobFile);
                               REPEAT
                                  READ(AircMiltarytJobFile,JetJob);
                               UNTIL(JetJob.AircMiltarytJobId=-1) OR (EOF(AircMiltarytJobFile));
                               WITH JetJob DO
                               BEGIN
                                  AircMiltarytJobId:=NewTaskId;
                                  JobId:=job.JobId;
                                  AircMiltarytId:=JetId;
                                  Complete:=FALSE;
                                  WRITE(AircMiltarytJobFile,JetJob);
                               END;
                            END;
                         END;
                      END;
                   END;
                END;
            'E':Addauths;
         END;
      END;

   PROCEDURE AddRecord;
      VAR
         AnotherAdd:CHAR;
         FileId:STRING[7];
      BEGIN
         REPEAT
            CLRSCR;
            Collectdata;
            CASE Choice OF
               'A':BEGIN
                      RESET(StaffFile);
                      REPEAT
                         READ(StaffFile,Staff);
                      UNTIL (Staff.StaffIdcode ='-1') OR (EOF(StaffFile));
                      IF Staff.StaffIdcode ='-1' THEN
                      SEEK(StaffFile,FILEPOS(StaffFile)-1);
                      WRITE(StaffFile,NewRecStaff);
                      WRITELN('Do you whis to add another record?(Y=yes N=No)');
                      AnotherAdd:=UPCASE(READKEY);

                   END;

               'B':BEGIN
                      RESET(AircMiltarytFile);
                      REPEAT
                         READ(AircMiltarytFile,Jet);
                      UNTIL (Jet.AIrcMiltarytId ='-1') OR (EOF(AIrcMiltarytFile));
                      IF Jet.AircMiltarytId='-1' THEN
                      SEEK(AircMiltarytFile, FILEPOS(AircMiltarytFile)-1);
                      WRITE(AircMiltarytFile, NewRecJet);
                      WRITELN('Do you want to add another record?(Y/N Y=Yes N=No)');
                      AnotherAdd :=UPCASE(READKEY);

                   END;
               'C':BEGIN
                      RESET(JobFile);
                         REPEAT
                            READ(JobFile,Job);
                         UNTIL (Job.JobId ='-1') OR (EOF(JobFile));
                         IF Job.JobId ='-1' THEN
                         SEEK(JobFile, FILEPOS(JobFile)-1);
                         WRITE(JobFile,NewRecJob);
                         WRITELN('Do you want to add another record?(Y/N Y=Yes N=No)');
                         AnotherAdd :=UPCASE(READKEY);
                   END;
               'D':BEGIN
                      REPEAT
                         WRITELN('Do you want to add another record?(Y/N Y=Yes N=No)');
                         AnotherAdd :=UPCASE(READKEY);
                         IF (AnotherAdd <>'Y') AND (Anotheradd<>'N') THEN
                         WRITELN('Invalid input please try again');
                         WRITELN;
                         WRITELN('Press anykey to continue');
                         READKEY;
                      UNTIL (Anotheradd='Y') OR (AnotherAdd='N');
                   END;
            END;

         UNTIL AnotherAdd ='N';
      END;


   PROCEDURE Addjob;
      VAR
         Complete,Qualified,Valid,Free,Trained:BOOLEAN;
         Times,Count,RankRequirment,Pos,TodayYear,TodayMonth,TodayDay,TodayNo:LONGINT;
         Differance,Largest,day,JobDay,Latest,StaffLocation,NewTask:LONGINT;
         JobMembers:StaffArray;
         Find,JobSelection:CHAR;
         JetId:STRING[5];
         JobRole:STRING[15];
      BEGIN
         WRITELN('Please select the aircMiltaryt that needs servecing');
         WRITELN;
         WRITELN('Press any key to continue');
         Find:='B';
         Search(Find);
         JetId:=Jet.AircMiltarytId;
         REPEAT
            CLRSCR;
            WRITELN('Please select the job you wish to assign');
            WRITELN('Press 1 to select wheel change');
            WRITELN('Press 2 to select engine change');
            WRITELN('Press 3 to select brake pad change');
            WRITELN('Press 4 to select oil filter change');
            WRITELN('Press 5 to select bulb change');
            WRITELN('Press 6 to select flight control surface change');
            WRITELN('Press 7 to select hydrolic actulator');
            WRITELN('Press 8 to select role change');
            JobSelection:=UPCASE(READKEY);
            WITH Job DO
            CASE JobSelection OF
               '1':JobId:='A0001';
               '2':JobId:='A0002';
               '3':JobId:='A0003';
               '4':JobId:='A0004';
               '5':JobId:='A0005';
               '6':JobId:='A0006';
               '7':JobId:='A0007';
               '8':JobId:='A0008';
               ELSE
               BEGIN
                  WRITELN;
                  WRITELN('Invalip input please enter a value displayed within the menu');
                  WRITELN;
                  WRITELN('Press any key to continue');
                  READKEY;
               END;
            END;
         UNTIL (ORD(JobSelection)>48) AND (ORD(JobSelection)<57);
          GETDATE(TodayYear,TodayMonth,TodayDay,TodayNo);
          Day:=(TodayMonth-1)*31+TodayDay;
          Row:=1;
          Count:=0;
          Qualified:=FALSE;
          BEGIN
             FOR POS:=1 TO 5 DO
             JobMembers[Pos]:='-1';
          END;
          Free:=FALSE;
          Valid:=FALSE;
          Times:=JobTest(Job.JobId);
          RankRequirment:=RankTest(Staff.Rank);
          JobRole:=RoleTest(Job.JobId);
          WITH Staff DO
          BEGIN
             Pos:=0;
             RESET(StaffFile);
             REPEAT
                READ(StaffFile,Staff);
                Trained:=RoleCheck(StaffIdcode,JobRole);
                Qualified:=AuthTest(Job.JobId,StaffIdcode);
                IF (Qualified=TRUE) AND (Trained=TRUE) THEN
                BEGIN
                   Pos:=Pos+1;
                   Jobmembers[Pos]:=StaffIdcode;
                   Count:=Count+1;
                   Qualified:=FALSE;
                END;
             UNTIL (Count=Times) OR (EOF(StaffFile));
             IF Count=Times THEN
             BEGIN
               // WRITELN('here');
              //  READKEY;
                Valid:=MemberTest(JobMembers,Times,Job.JobId);
                IF Valid = TRUE THEN
                BEGIN
                   Latest:=0;
                   Largest:=0;
                   FOR Pos:=1 TO Times DO
                   BEGIN
                      RESET(StaffFile);
                      REPEAT
                         READ(StaffFile,Staff);
                      UNTIL(Staffidcode=JobMembers[Pos]);
                      BEGIN
                         REPEAT
                            IF Free=FALSE THEN
                            BEGIN
                               Day:=Day+1;
                               Row:=1;
                            END;
                            REPEAT
                               IF Schedule[Row,Day] ='-1' THEN
                               Free:=TRUE
                               ELSE Row:=Row+1;
                            UNTIL (Free) OR (Row>8);
                         UNTIL Free;
                         JobDay:=(TodayMonth-1)*31 + TodayDay;
                         DIfferance:=Day-JobDay ;
                         IF Differance>Largest THEN
                         Largest:=Differance;
                         IF Row>Latest THEN
                         Latest:=Row;
                      END;
                   END;
                END;
                BEGIN
                   JobDay:=Day+Differance;
                   Newtask:=GenerateId;
                   BEGIN
                      FOR Pos:=1 TO Times DO
                      IF Jobmembers[Pos] <>'-1' THEN
                      BEGIN
                         RESET(StaffFile);
                         REPEAT
                            READ(StaffFile,Staff);
                         UNTIL Staff.StaffIdCode=JobMembers[Pos];
                         StaffLocation:=FILEPOS(StaffFile);
                         SEEK(StaffFile,StaffLocation-1);
                         Schedule[Row,day]:=INTTOSTR(NewTask);
                         WRITE(StaffFile,Staff);
                      END;
                   END;
                   WRITELN('Job succesfuly added press any key to continue');
                   READKEY;
                   WITH JetJob DO
                   BEGIN
                      RESET(AircMiltarytJobFile);
                      REPEAT
                         READ(AircMiltarytJobFile,JetJob);
                      UNTIL(AircMiltarytJobId=-1) OR (EOF(AircMiltarytJobFile));
                      AircMiltarytJobId:=NewTask;
                      AircMiltarytId:=JetId;
                      JobID:=Job.JObID;
                      Complete:=FALSE;
                      WRITE(AircMiltarytJobFile,JetJob);
                   END;
                END;
                IF Count<> Times THEN
                BEGIN
                   WRITELN('There are not enough valid staff members to complete this job');
                   WRITELN;
                   WRITELN('Press any key to continue');
                   READKEY;
                END;
             END;
          END;
      END;

   PROCEDURE Delete;
      VAR
         DelOption,SearchChoice:CHAR;
         AnotherDel:CHAR;
         MemberID:STRING[5];
      BEGIN
         REPEAT
            CLRSCR;
            WRITELN('Please select one of the following options');
            WRITELN;
            WRITELN('Press A to search for a member of staff');
            WRITELN('Press B to search for a aircMiltaryt');
            WRITELN('Press x to exit');
            Choice:=UPCASE(READKEY);
            CASE Choice OF
               'A': BEGIN
                       SearchChoice:='A';
                       Search(SearchChoice);
                       MemberId:=Staff.StaffIdCode;
                       REPEAT
                          WRITELN('Are you sure you want to delete this item(Y/N)');
                          DelOption:=UPCASE(READKEY);
                          IF (DelOption<'Y') AND (DelOption<>'N') THEN
                          BEGIN
                             WRITELN('Invalid input please try again');
                             WRITELN;
                             WRITELN('Press anykey to continue');
                             READKEY;
                          END;
                       UNTIL (DelOption='Y') OR (DelOption='N');
                       CASE DelOption OF
                          'Y': BEGIN
                                  REPEAT
                                     Staff.StaffIdcode := '-1';
                                     SEEK(StaffFile, FILEPOS(StaffFile)-1);
                                     WRITE(StaffFile,Staff);
                                     RESET(StaffAuthsFile);
                                     WHILE NOT EOF(StaffAUthsFile) DO
                                     BEGIN
                                        WITH StaffAuths DO
                                        BEGIN
                                           READ(STaffAuthsFile,StaffAuths);
                                           IF StaffAuths.StaffID=MemberID THEN
                                           StaffauthID:='-1';
                                           StaffId:='-1';
                                           WRITE(StaffAuthsFile,StaffAuths);
                                        END;
                                     END;
                                     WRITELN('Your item has been deleted');
                                     WRITELN('Do you wish to delete another record (Y/N)');
                                     AnotherDel:=UPCASE(READKEY);
                                     IF (AnotherDel<>'Y') AND (AnotherDel<>'N') THEN
                                     BEGIN
                                        WRITELN('Invalid input please try again');
                                        WRITELN;
                                        WRITELN('Press anykey to continue');
                                        READKEY;
                                     END;
                                  UNTIL (AnotherDel='Y') OR (AnotherDel='N');
                               END;
                          'N':BEGIN
                                 REPEAT
                                    WRITELN;
                                    WRITELN('Do you wish to search for another item (Y/N)');
                                    AnotherSearch:=UPCASE(READKEY);
                                    IF (AnotherSearch <>'Y') AND (AnotherSearch <>'N') THEN
                                    BEGIN
                                       WRITELN('Invalid Input please try again');
                                       WRITELN;
                                       WRITELN('Press anykey to continue');
                                       READKEY;
                                    END;
                                 UNTIL (AnotherSearch ='Y') OR (AnotherSearch = 'N');
                              END;
                          ELSE
                          WRITELN('Invalid input please try again');
                       END;
                    END;

               'B':BEGIN
                      SearchChoice:='B';
                      Search(SearchChoice);
                      REPEAT
                         WRITELN;
                         WRITELN('Are you sure you want to delete this item(Y/N)');
                         DelOption:=UPCASE(READKEY);
                         IF (DelOption<'Y') AND (DelOption<>'N') THEN
                          BEGIN
                             WRITELN('Invalid input please try again');
                             WRITELN;
                             WRITELN('Press anykey to continue');
                             READKEY;
                          END;
                      UNTIL (DelOption='Y') OR (DelOption='N');
                      CASE DelOption OF
                         'Y': BEGIN
                                 REPEAT
                                    Jet.AircMiltarytId := '-1';
                                    SEEK(AircMiltarytFile, FILEPOS(AircMiltarytFile)-1);
                                    WRITE(AircMiltarytFile,Jet);
                                    WRITELN('Your item has been deleted');
                                    WRITELN('Do you wish to delete another record (Y/N)');
                                    AnotherDel:=UPCASE(READKEY);
                                    IF (AnotherDel<>'Y') AND (AnotherDel<>'N') THEN
                                    BEGIN
                                       WRITELN('Invalid input please try again');
                                       WRITELN;
                                       WRITELN('Press anykey to continue');
                                       READKEY;
                                    END;
                                 UNTIL (AnotherDel='Y') OR (AnotherDel='N');
                              END;

                         'N':BEGIN
                                REPEAT
                                   WRITELN('Do you wish to search for another item (Y/N)');
                                   AnotherSearch:=UPCASE(READKEY);
                                   IF (AnotherSearch <>'Y') AND (AnotherSearch <>'N') THEN
                                   BEGIN
                                      WRITELN('Invalid Input please try again');
                                      WRITELN;
                                      WRITELN('Press anykey to continue');
                                      READKEY;
                                   END;
                                UNTIL (AnotherSearch ='Y') OR (AnotherSearch = 'N');
                             END;
                         ELSE
                         WRITELN('Invalid input please try again');
                      END;
                   END;
               ELSE
               BEGIN
                  WRITELN('Invalid input please try again');
                  WRITELN;
                  WRITELN('Press any key to continue');
                  READKEY;
               END;
            END;
         UNTIL (AnotherDel ='N') OR (AnotherSearch='N');
      END;


   PROCEDURE AmendPersonalData(AdminMember:BOOLEAN);
      VAR
         Selection:CHAR;
         EmployeePostion:LONGINT;
         Firstname,Lastname:STRING[20];
      BEGIN
         REPEAT
            WITH Staff DO
            BEGIN
               CLRSCR;
               WRITELN('ID number: ',StaffIdCode);
               WRITELN('Name: ',Forename,' ',Surname);
               WRITELN('Job feild: ',Jobfeild);
               WRITELN('Rank: ',Rank);
               WRITELN;
               REPEAT
                  WRITELN('Please select the information you wish to amend');
                  WRITELN;
                  WRITELN('Press 1 to amend the staff members  name');
                  WRITELN('Press 2 to amend the staff members Job role');
                  IF AdminMember THEN
                  WRITELN('Press 3 to amend the staff members rank');
                  WRITELN('Press 4 to amend the staff members password');
                  WRITELN('Press E to exit');
                  Options:=UPCASE(READKEY);
                  CASE Options OF
                     '1':BEGIN
                            REPEAT
                               WRITELN('Please enter the required forename:');
                               READLN(Firstname);
                               IF (LENGTH(Firstname)>15) OR (LENGTH(Firstname)=0) THEN
                               BEGIN
                                  WRITELN('Error there is an invalid amount of charecters within this name pleaase re enter your name or contact the system admisartor');
                                  WRITELN;
                                  WRITELN('Press anykey to continue');
                                  READKEY;
                                  WRITELN;
                               END;
                            UNTIL (LENGTH(Firstname)<=15) AND (LENGTH(Firstname)>0);
                            Forename:=Firstname;
                            WRITELN;
                            REPEAT
                               WRITELN('Please enter the required surname');
                               READLN(Lastname);
                                IF (LENGTH(Lastname)>15) OR (LENGTH(Lastname)=0) THEN
                                BEGIN
                                   WRITELN('Error there is an invalid amount of charecters within this name pleaase re enter your name or contact the system admisartor');
                                   WRITELN;
                                   WRITELN('Press anykey to continue');
                                   READKEY;
                                   WRITELN;
                                END;
                            UNTIL (LENGTH(Lastname)<=15) AND (LENGTH(lastname)>0);
                            Surname:=Lastname;
                         END;
                     '2':BEGIN
                            REPEAT
                               CLRSCR;
                               WRITELN('Please select your job role');
                               WRITELN('4:Avionics');
                               WRITELN('5:Mechainc');
                               WRITELN('6: Weapons technican');
                               Selection:=UPCASE(READKEY);
                               CASE Selection OF
                                  '4':JobFeild:='Avionics';
                                  '5':JobFeild:='Mechanics';
                                  '6':Jobfeild:='Weapons technican';
                                  ELSE
                                  WRITELN('Invalid input please try agian');
                                  WRITELN;
                                  WRITELN('Press anykey to continue');
                                  READKEY;
                               END;
                            UNTIL (ORD(Selection) < 55) AND (ORD(Selection) >51);
                         END;
                     '3':BEGIN
                            REPEAT
                               CLRSCR;
                               WRITELN('Please select one of the following ranks');
                               WRITELN('Press 1 for SAC');
                               WRITELN('Press 2 for Corporal');
                               WRITELN('Press 3 for sergant');
                               WRITELN('Press 4 for flight Sergant');
                               Selection:=UPCASE(READKEY);
                               CASE Selection OF
                                  '1':Staff.Rank:='SAC';
                                  '2':Staff.Rank:='Corporal';
                                  '3':Staff.Rank:='Sergant';
                                  '4':Staff.Rank:='Flight Sergant';
                                  ELSE
                                  WRITELN('Invalid input please try agian');
                                  WRITELN;
                                  WRITELN('Press anykey to continue');
                                  READKEY;
                               END;
                            UNTIL (ORD(Selection) <53) AND (ORD(Selection) >48);
                         END;
                     '4':Password:=Enterpassword;
                     'E':WRITELN;
                     ELSE
                     BEGIN
                        IF Options <>'E' THEN
                        BEGIN
                           WRITELN('Invalid input  please try again');
                           WRITELN('Press anykey to continue');
                           READKEY;
                        END;
                     END;
                  END;
               UNTIL (ORD(Options) >51) OR (ORD(Options) <49);
               SEEK(StaffFile,FILEPOS(StaffFile)-1);
               WRITE(StaffFile,Staff);
            END;
         UNTIL Options='E';
      END;

   PROCEDURE AmendRecord;
      VAR
         Selection,SearchOption,Confirm,MenuChar:CHAR;
         RecordNo,StrNo,ErrCode:lONGINT;
         Admin:BOOLEAN;
         LastService:STRING[3];
      BEGIN
         Admin:=FALSE;
         IF Staff.Rank='Flight Sergant' THEN
         Admin:=TRUE;
         REPEAT
            CLRSCR;
            WRITELN('please select which record you wish to amend');
            WRITELN('Press A to amend Personal information');
            IF Staff.Rank='Flight Sergant' THEN
            BEGIN
               WRITELN('press B to amend staff infomration');
               WRITELN('Press C to amend aircMiltaryt information');
             //  WRITELN('Press D to amend Job information');
            END;
            WRITELN('Press x to exit');
            MenuChar:=UPCASE(READKEY);
            CASE MenuChar OF
               'A':AmendPersonalData(Admin);

               'B':BEGIN
                      SearchOption:='A';
                      Search(SearchOption);
                      AmendPersonalData(Admin);
                      SEEK(StaffFile,StaffRecNo);
                      READ(StaffFile,Staff);
                   END;
               'C':BEGIN
                      REPEAT
                         SearchOption:='B';
                         SEARCH(SearchOption);
                         BEGIN
                            REPEAT
                               WITH Jet DO
                               BEGIN
                                  REPEAT
                                     WRITELN;
                                     WRITELN('Please select the data that you wish to amend');
                                     WRITELN('Press 1 to amend the flight hours since last service');
                                     WRITELN('Press 2 to amend the status of the aircMiltaryt');
                                     WRITELN('Press E to exit');
                                     Options:=UPCASE(READKEY);
                                     CASE Options OF
                                        '1':BEGIN
                                               REPEAT
                                                  BEGIN
                                                     REPEAT
                                                        WRITELN('Please enter the flight houes since last service:');
                                                        READLN(LastService);
                                                        WRITELN;
                                                        VAL(LastService,StrNo,ErrCode);
                                                        IF ErrCode <> 0 THEN
                                                        BEGIN
                                                           WRITELN('Invalid input please enter an integar');
                                                           WRITELN;
                                                           WRITELN('Press any key to continue');
                                                           READKEY;
                                                        END;
                                                        IF (STRTOINT(LastService)>=100) THEN
                                                        BEGIN
                                                           REPEAT
                                                              WRITELN('Are you sure you wish to enter this value (Y=yes,N=No)');
                                                              Confirm:=UPCASE(READKEY);
                                                              IF (Confirm<> 'Y') AND (Confirm <> 'N') THEN
                                                              BEGIN
                                                                 WRITELN('Invalid input please enter eitehr Y or N');
                                                                 WRITELN;
                                                                 WRITELN('Press any key to continue');
                                                                 READKEY;
                                                              END;
                                                           UNTIL (Confirm='Y') OR (Confirm='N');
                                                        END;
                                                     UNTIL ErrCode=0;
                                                     Flight_timefromService:=STRTOINT(LastService);
                                                     IF Flight_timefromService<0 THEN
                                                     BEGIN
                                                        WRITELN('Invalid input please re enter the data');
                                                        WRITELN;
                                                        WRITELN('Press any key to continue');
                                                        READKEY;
                                                     END;
                                                  END;
                                               UNTIL Flight_timefromService>=0;
                                            END;

                                        '2':BEGIN
                                               REPEAT
                                                  CLRSCR;
                                                  WRITELN('Please select the status of the aircMiltaryt');
                                                  WRITELN('4: Servicable');
                                                  WRITELN('5: Unservicable');
                                                  WRITELN('6: Job in progress');
                                                  WRITELN('7: Airborn');
                                                  Selection:=UPCASE(READKEY);
                                                  CASE Selection OF
                                                     '4':AircMiltarytstatus:='Servicable';
                                                     '5':AircMiltarytstatus:='Unservicable';
                                                     '6':BEGIN
                                                            AircMiltarytstatus:='Job in progress';
                                                            Flight_timefromservice:=0;
                                                         END;
                                                     '7':AircMiltarytstatus:='Airborn';
                                                     ELSE
                                                     BEGIN
                                                        WRITELN;
                                                        WRITELN('Invalid input please try agian');
                                                        WRITELN;
                                                        WRITELN('Press any key to continue');
                                                        READKEY
                                                     END;
                                                  END;
                                               UNTIL (ORD(Selection) < 56) AND (ORD(Selection) >51);
                                            END;
                                        'E':WRITELN;
                                        ELSE
                                        BEGIN
                                           WRITELN('Invalid input  please try again');
                                           WRITELN('Press anykey to continue');
                                           READKEY;
                                        END;
                                     END;
                                  UNTIL Options='E';
                               END;
                               BEGIN
                                  REPEAT
                                     WRITELN;
                                     WRITELN('Do you wish to amend another data item?(Y=yes, N=No)');
                                     Entrey:=UPCASE(READKEY);
                                     IF (Entrey <> 'Y') AND (Entrey <>'N') THEN
                                     BEGIN
                                        WRITELN('Invalid input please try again');
                                        WRITELN;
                                        WRITELN('Press anykey to continue');
                                        READKEY;
                                     END;
                                  UNTIL (Entrey ='Y') OR (Entrey='N');
                               END;
                            UNTIL (ORD(Options) >51) AND (ORD(Options) <49) OR (Entrey='N');
                         END;
                         BEGIN
                            REPEAT
                               WRITELN;
                               WRITELN('Do you wish to search for another recrod to amend? (Y=Yes, N=No)');
                               Anothersearch:=UPCASE(READKEY);
                               IF (AnotherSearch <> 'N') AND (AnotherSearch <>'Y') THEN
                               BEGIN
                                  WRITELN('Invalid input please try again');
                                  WRITELN;
                                  WRITELN('Press anykey to continue');
                                  READKEY;
                               END;
                            UNTIL (AnotherSearch='Y') OR (AnotherSearch='N');
                         END;
                      UNTIL (Located) OR (Options='N') OR (AnotherSearch='N');
                      SEEK(AircMiltarytFile,FILEPOS(AircMiltarytFile)-1);
                      WRITE(AircMiltarytFile,Jet);
                   END;
               'X':WRITELN;
               ELSE
               BEGIN
                  WRITELN;
                  WRITELN('Invalid input please try again');
                  WRITELN;
                  WRITELN('Press any key to continue');
                  READKEY;
               END;
            END;
         UNTIL menuChar='X';
      END;



   PROCEDURE Recovrey;
      VAR
         Select:CHAR;
      BEGIN
         REPEAT
            WRITELN('Are you sure you wish to recover the last backup backup of the current data(Y=Yes,N=No)');
            WRITELN;
            WRITELN('The current data within the system will be lost');
            Select:=UPCASE(READKEY);
            IF (Select<>'Y') AND (Select<>'N') THEN
            BEGIN
               WRITELN('Error invalis input please try again');
               WRITELN;
               WRITELN('Press anykey to continue');
               READKEY;
            END;
         UNTIL (Select='Y') OR (Select='N');
         IF Select='Y' THEN
         BEGIN
            REWRITE(StaffFile);
            RESET(StaffBackup);
            REPEAT
               READ(Staffbackup,Staff);
               WRITE(Stafffile,Staff);
            UNTIL EOF(Staffbackup);
            CLOSE(Stafffile);
            REWRITE(Jobfile);
            RESET(Jobbackup);
            REPEAT
               READ(JobBackup,Job);
               WRITE(Jobfile,Job);
            UNTIL EOF(Jobbackup);
            CLOSE(Jobfile);
            REWRITE(AircMiltarytfile);
            RESET(AircMiltarytbackup);
            REPEAT
                READ(AircMiltarytBackup,Jet);
                WRITE(AircMiltarytFile,Jet);
            UNTIL EOF(AircMiltarytBackup);
            CLOSE(AircMiltarytFile);
            REWRITE(AuthFile);
            RESET(AuthBackup);
            REPEAT
               READ(AuthBackup,Auth);
               WRITE(AuthFile,Auth);
            UNTIL EOF(AuthBackup);
            CLOSE(AuthFile);
            REWRITE(StaffAuthsFile);
            RESET(StaffAuthBackup);
            REPEAT
               READ(StaffAuthBackup,StaffAuths);
               WRITE(StaffAuthsFile,StaffAuths);
            UNTIL EOF(StaffAuthBackup);
            CLOSE(StaffAuthsFile);
            REWRITE(WorkFile);
            RESET(WorkBackup);
            REPEAT
               READ(WorkBAckup,Work);
               WRITE(WorkFile,Work);
            UNTIL EOF(WorkBackup);
            CLOSE(WorkFile);
            REWRITE(WorkJobFile);
            RESET(WorkJobBackup);
            REPEAT
               READ(WorkJobBackup,WorkJob);
               WRITE(WorkJobFile,WorkJob);
            UNTIL EOF(WorkJobBAckup);
            CLOSE(WorkJobFile);
            REWRITE(AircMiltarytJobFile);
            RESET(JetJobBackup);
            REPEAT
               READ(JetJobBackup,JetJob);
               WRITE(AircMiltarytJobFIle,JetJob);
            UNTIL EOF(JetJobBAckup);
            CLOSE(AircMiltarytJobFile);
            REWRITE(TaskIdfile);
            RESET(TaskBAckup);
            REPEAT
               READ(TaskBackup,NewId);
               WRITE(TaskIdFile,NewId);
            UNTIL EOF(TaskBAckup);
            CLOSE(TaskIdFile);
            WRITELN;
            WRITELN('Recovrey complete press any key to continue');
            READKEY;
         END
         ELSE
         BEGIN
            WRITELN;
            WRITELN('Recovrey canceled press any key to continue');
            READKEY;
         END;
      END;

   PROCEDURE Backup;
      VAR
         Select:CHAR;
      BEGIN
         REPEAT
            WRITELN('Are you sure you wish to create a backup of the current data(Y=Yes,N=No)');
            Select:=UPCASE(READKEY);
            IF (Select<>'Y') AND (Select<>'N') THEN
            BEGIN
               WRITELN('Error invalis input please try again');
               WRITELN;
               WRITELN('Press anykey to continue');
               READKEY;
            END;
         UNTIL (Select='Y') OR (Select='N');
         IF Select='Y' THEN
         BEGIN
            REWRITE(StaffBackup);
            RESET(StaffFile);
            REPEAT
               READ(StaffFile,Staff);
               WRITE(StaffBackup,Staff);
            UNTIL EOF(StaffFile);
            CLOSE(StaffBackup);
            REWRITE(JobBackup);
            RESET(JobFile);
            REPEAT
               READ(JobFile,Job);
               WRITE(JobBackup,Job);
            UNTIL EOF(JobFile);
            CLOSE(JobBackup);
            REWRITE(AircMiltarytBackup);
            RESET(AircMiltarytFile);
            REPEAT
                READ(AircMiltarytFile,Jet);
                WRITE(AircMiltarytBackup,Jet);
            UNTIL EOF(AircMiltarytFile);
            CLOSE(AircMiltarytBackup);
            REWRITE(AuthBackup);
            RESET(AuthFile);
            REPEAT
               READ(AuthFile,Auth);
               WRITE(AuthBackup,Auth);
            UNTIL EOF(AuthFile);
            CLOSE(AuthBackup);
            REWRITE(StaffAuthBackup);
            RESET(StaffAuthsFile);
            REPEAT
               READ(StaffAuthsFile,StaffAuths);
               WRITE(StaffAuthBackup,StaffAuths);
            UNTIL EOF(StaffAuthsFile);
            CLOSE(StaffAuthBackup);
            REWRITE(WorkBackup);
            RESET(WorkFile);
            REPEAT
               READ(WorkFile,Work);
               WRITE(WorkBackup,Work);
            UNTIL EOF(WorkFile);
            CLOSE(WorkBackup);
            REWRITE(WorkJobBackup);
            RESET(WorkJobFile);
            REPEAT
               READ(WorkJobFile,WorkJob);
               WRITE(WorkJobBackup,WorkJob);
            UNTIL EOF(WorkJobFile);
            CLOSE(WorkJobBackup);
            REWRITE(JetJobBackup);
            RESET(AircMiltarytJobFile);
            REPEAT
               READ(AircMiltarytJobFile,JetJob);
               WRITE(JetJobBackup,JetJob);
            UNTIL EOF(AircMiltarytJobFile);
            CLOSE(JetJobBackup);
            REWRITE(TaskBackup);
            RESET(TaskIdFile);
            REPEAT
               READ(TaskIdFile,NewId);
               WRITE(TaskBackup,NewId);
            UNTIL EOF(TaskIDFile);
            CLOSE(TaskBackup);
            WRITELN;
            WRITELN('Backup complete press any key to continue');
            READKEY;
         END
         ELSE
         BEGIN
            WRITELN;
            WRITELN('Backup cancled press any key to continue');
            READKEY;
         END;
      END;

   PROCEDURE BackupAndRecovrey;
      VAR
         MenuChoice:CHAR;
      BEGIN
         REPEAT
            CLRSCR;
            WRITELN('Press A to create a backup of the current data');
            WRITELN('Press B to recover the latest backup');
            WRITELN('Press X to exit');
            Menuchoice:=UPCASE(READKEY);
            CASE Menuchoice OF
               'A':Backup;
               'B':Recovrey;
               'X':WRITELN;
               ELSE
               BEGIN
                  WRITELN;
                  WRITELN('Invalid input please enetr one of the values dispalyed above');
                  WRITELN;
                  WRITELN('Press any key to continue');
                  READKEY;
               END;
            END;
         UNTIL Menuchoice='X';
      END;

   PROCEDURE AdminMenu;
      BEGIN
         REPEAT
            CLRSCR;
            SEEK(StaffFile,StaffRecNo);
            READ(StaffFile,Staff);
            WRITELN('                Welcome to Miltary servecing schedule');
            WRITELN;
            WRITELN('Press A to view the data within the file');
            WRITELN('Press B to search the system');
            WRITELN('Press C to add a new Record to a file');
            WRITELN('Press D to delete a record');
            WRITELN('Press E to amend a record');
            WRITELN('Press F to view your weekly roster');
            WRITELN('Press G to auto assign a job');
            WRITELN('Press H to access Back up and recovrey');
            WRITELN('Press X to exit');
            Choice:=UPCASE(READKEY);
            CASE Choice OF
               'A':ViewFile;
               'B':Search('0');
               'C':AddRecord;
               'D':Delete;
               'E':AmendRecord;
               'F':ShowDate;
               'G':AddJob;
               'H':BackupAndRecovrey;
               'X':WRITELN;
               ELSE
               BEGIN
                  WRITELN;
                  WRITELN('Invalid input please selectedone of the options within the menu');
                  WRITELN;
                  WRITELN('Press anykey to continue');
                  READKEY;
               END;
            END;
         UNTIL Choice ='X';

      END;

   PROCEDURE MainMenu;
      BEGIN
         REPEAT
            CLRSCR;
            WRITELN('Press A to view your personal data');
            WRITELN('Press B to amend your personal data');
            WRITELN('Press C to view your weekly roster');
            WRITELN('Press X to exit');
            Choice:=UPCASE(READKEY);
            CASE Choice OF
               'A':DisplayRecord;
               'B':AmendRecord;
               'C':ShowDate;
               'X':WRITELN;
               ELSE
               BEGIN
                  WRITELN;
                  WRITELN('Invalid input please selected one of the options within the menu');
                  WRITELN;
                  WRITELN('Press any key to continue');
                  READKEY;
               END;
            END;
         UNTIL Choice='X';
      END;
   PROCEDURE LOGIN;
      VAR
         Search:BOOLEAN;
         Found:BOOLEAN;
         PassChar:CHAR;
         Passphrase:STRING[10];
      BEGIN
         WITH Staff DO
         REPEAT
            CLRSCR;
            RESET(StaffFile);
            WRITELN('         Miltary service schedule');
            WRITELN;
            WRITELN('Welcome to Miltary service schedules servecing database');
            RESET(StaffFile);
            WRITELN('Please enter your username');
            READLN(Entrey);
            WRITELN;
            Search:=FALSE;
               BEGIN
                  REPEAT
                     READ(StaffFile,Staff);
                     IF UPPERCASE(Username) = UPPERCASE(ENTREY) THEN
                        BEGIN
                           Search:=TRUE;
                              BEGIN
                                 WRITELN('Thankyou press anykey to continue');
                                 READKEY;
                              END;
                        END;
                  UNTIL (Search) OR (EOF(StaffFile));
                  Passphrase:='';
                  WRITELN('Please enter your password');
                  REPEAT
                     Passchar:=READKEY;
                     IF ORD(Passchar) <> 13 THEN
                        BEGIN
                           Passphrase := Passphrase + passchar;
                           WRITE('*');
                        END;
                          BEGIN
                             IF ORD(Passchar) =8 THEN
                                BEGIN
                                   Passphrase := COPY(Passphrase,1,LENGTH(Passphrase)-2);
                                   GOTOXY(WHEREX-2,WHEREY);
                                   WRITE('  ');
                                   GOTOXY(WHEREX-2,WHEREY);
                                END;
                          END;
                  UNTIL ORD(Passchar) =13;

                  BEGIN
                     Found:=FALSE;
                     IF UPPERCASE(Passphrase) =UPPERCASE(Password) THEN
                     Found:=TRUE;
                     StaffRecNo:=FILEPOS(StaffFile)-1;
                     BEGIN
                        IF (Found=TRUE) AND (Search=TRUE) THEN
                        BEGIN
                           WRITELN('Welcome!');
                           SEEK(StaffFile,StaffRecNo);
                           READ(StaffFile,Staff);
                           IF Staff.Rank ='Flight Sergant' THEN
                           AdminMenu
                           ELSE
                           Mainmenu;
                        END;
                        IF (Found=FALSE) OR (Search=FALSE) THEN
                        BEGIN
                           WRITELN;
                           WRITELN('Incorrect password or username please try again');
                           WRITELN('Press anykey to continue');
                           READKEY;
                           CLRSCR;
                        END;
                     END;
                  END;
               END;
         UNTIL (FOUND=TRUE) AND(Search=TRUE);
      END;



   BEGIN
      WRITELN('Please select the drive that you wish to use');
      Drive:=UPCASE(READKEY);
      ASSIGN(StaffFile,       Drive+':\Adam sixth form\Cg4  staff schedule\Staff.dta');
      ASSIGN(JobFile,         Drive+':\Adam sixth form\Cg4  staff schedule\Job.dta');
      ASSIGN(AircMiltarytFile,    Drive+':\Adam sixth form\Cg4  staff schedule\AircMiltaryt.dta');
      ASSIGN(AuthFile,        Drive+':\Adam sixth form\Cg4  staff schedule\Auth.dta');
      ASSIGN(StaffAuthsFile,  Drive+':\Adam sixth form\Cg4  staff schedule\StaffAuths.dta');
      ASSIGN(WorkFile,        Drive+':\Adam sixth form\Cg4  staff schedule\Work.dta');
      ASSIGN(WorkJobFile,     Drive+':\Adam sixth form\Cg4  staff schedule\WorkJob.dta');
      ASSIGN(AircMiltarytJobFile, Drive+':\Adam sixth form\Cg4  staff schedule\AircMiltarytJob.dta');
      ASSIGN(TaskIdFile,      Drive+':\Adam sixth form\Cg4  staff schedule\TaskId.dta');

      ASSIGN(StaffBackup,     Drive+':\Adam sixth form\Cg4  Backup files\StaffBackup.dta');
      ASSIGN(JobBackup,       Drive+':\Adam sixth form\Cg4  Backup files\JobBackUp.dta');
      ASSIGN(AircMiltarytBackup,  Drive+':\Adam sixth form\Cg4  Backup files\AircMiltarytBackup.dta');
      ASSIGN(AuthBackup,      Drive+':\Adam sixth form\Cg4  Backup files\AuthBackup.dta');
      ASSIGN(StaffAuthBackup, Drive+':\Adam sixth form\Cg4  Backup files\StaffAuthBackup.dta');
      ASSIGN(WorkBackup,      Drive+':\Adam sixth form\Cg4  Backup files\WorkBackup.dta');
      ASSIGN(WorkJobBackup,   Drive+':\Adam sixth form\Cg4  Backup files\WorkJobBackup.dta');
      ASSIGN(JetJobBackup,    Drive+':\Adam sixth form\Cg4  Backup files\JetJobBackup.dta');
      ASSIGN(TaskBackup,      Drive+':\Adam sixth form\Cg4  Backup files\TaskIdBackup.dta');
      LOGIN;
      CLOSE(StaffFile);
      CLOSE(JobFile);
      CLOSE(AircMiltarytFile);
      CLOSE(AuthFile);
      CLOSE(StaffAuthsFile);
      CLOSE(WorkFile);
      CLOSE(WorkJobFile);
      CLOSE(AircMiltarytJobFile);
      CLOSE(TaskIdFile);

      CLOSE(StaffBackup);
      CLOSE(JobBackup);
      CLOSE(AircMiltarytBackup);
      CLOSE(AuthBackup);
      CLOSE(StaffAuthBackup);
      CLOSE(WorkBackup);
      CLOSE(WorkJobFile);
      CLOSE(JetJobBackup);
      CLOSE(TaskBackup);
   END.

