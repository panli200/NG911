class SOSUser {
  bool generalPermission = false;
  String message = '';
  String contactNum = '';
  bool medicalPermission = false;
  String personalHealthNum = '';
  String personalMedicalFile = 'No File Selected';
  bool contactMedicalPermission = false;
  String contactHealthNum = '';
  String contactMedicalFile = 'No File Selected';

  SOSUser(){
    this.generalPermission = generalPermission;
    this.message = message;
    this.contactNum = contactNum;
    this.medicalPermission = medicalPermission;
    this.personalHealthNum = personalHealthNum;
    this.personalMedicalFile = personalMedicalFile;
    this.contactMedicalPermission = contactMedicalPermission;
    this.contactHealthNum = contactHealthNum;
    this.contactMedicalFile = contactMedicalFile;
  }
}