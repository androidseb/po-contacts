//ignore_for_file: non_constant_identifier_names
class I18nString {
  final String app_name = 'app_name';
  final String create_new_contact = 'create_new_contact';
  final String export_all_as_vcf = 'export_all_as_vcf';
  final String about = 'about';
  final String about_message = 'about_message';
  final String ok = 'ok';
  final String new_contact = 'new_contact';
  final String edit_contact = 'edit_contact';
  final String save = 'save';
  final String full_name = 'full_name';
  final String phone = 'phone';
  final String email = 'email';
  final String phones = 'phones';
  final String emails = 'emails';
  final String field_cannot_be_empty = 'field_cannot_be_empty';
  final String contact_details = 'contact_details';
  final String delete_contact = 'delete_contact';
  final String delete_contact_confirmation_message = 'delete_contact_confirmation_message';
  final String yes = 'yes';
  final String no = 'no';
  final String add_email = 'add_email';
  final String add_phone = 'add_phone';
  final String add_address = 'add_address';
  final String address = 'address';
  final String organization_name = 'organization_name';
  final String organization_title = 'organization_title';
  final String notes = 'notes';
  final String home_list_empty_placeholder_text = 'home_list_empty_placeholder_text';
  final String remove_entry = 'remove_entry';
  final String incorrect_email_address_format = 'incorrect_email_address_format';
  final String label_type_work = 'label_type_work';
  final String label_type_home = 'label_type_home';
  final String label_type_cell = 'label_type_cell';
  final String label_type_fax = 'label_type_fax';
  final String label_type_pager = 'label_type_pager';
  final String label_type_custom = 'label_type_custom';
  final String custom_label = 'custom_label';
  final String cancel = 'cancel';
  final String quick_actions = 'quick_actions';
  final String call_x = 'call_x';
  final String text_x = 'text_x';
  final String email_x = 'email_x';
  final String search_list_empty_placeholder_text = 'search_list_empty_placeholder_text';
  final String import_file_title = 'import_file_title';
  final String import_file_question = 'import_file_question';
  final String share_prompt_title = 'share_prompt_title';
  final String street_address = 'street_address';
  final String locality = 'locality';
  final String region = 'region';
  final String postal_code = 'postal_code';
  final String country = 'country';
  final String website = 'website';
  final String first_name = 'first_name';
  final String last_name = 'last_name';
  final String nickname = 'nickname';
  final String addresses = 'addresses';
  final String addresses_with_type_x = 'addresses_with_type_x';
  final String organization_division = 'organization_division';
  final String loading = 'loading';
  final String importing = 'importing';
  final String export_completed = 'export_completed';
  final String exported_contacts_to_file_x = 'exported_contacts_to_file_x';
  final String exporting = 'exporting';
  final String change_image = 'change_image';
  final String select_image = 'select_image';
  final String from_gallery = 'from_gallery';
  final String from_camera = 'from_camera';
  final String delete_image = 'delete_image';
}

class I18n {
  static final I18nString string = I18nString();

  static Map<String, String> currentTranslation = {
    string.app_name: 'PO Contacts',
    string.create_new_contact: 'Create new contact',
    string.export_all_as_vcf: 'Export all as VCF file',
    string.about: 'About (v%s)',
    string.about_message: 'About message here',
    string.ok: 'OK',
    string.new_contact: 'New contact',
    string.edit_contact: 'Edit contact',
    string.save: 'Save',
    string.full_name: 'Full name',
    string.phone: 'Phone',
    string.email: 'Email',
    string.phones: 'Phone(s)',
    string.emails: 'Email(s)',
    string.field_cannot_be_empty: 'This field cannot be empty',
    string.contact_details: 'Contact details',
    string.delete_contact: 'Delete contact',
    string.delete_contact_confirmation_message: 'This will delete the contact permanently, are you sure?',
    string.yes: 'Yes',
    string.no: 'No',
    string.add_email: 'Add email',
    string.add_phone: 'Add phone',
    string.add_address: 'Add address',
    string.address: 'Address',
    string.organization_name: 'Organization name',
    string.organization_title: 'Organization title',
    string.notes: 'Notes',
    string.home_list_empty_placeholder_text: 'Your list of contacts is currently empty. You can add a contact by clicking the + button, or you can import contacts by opening a file from your system.',
    string.remove_entry: 'Remove entry',
    string.incorrect_email_address_format: 'Incorrect email address format',
    string.label_type_work: 'Work',
    string.label_type_home: 'Home',
    string.label_type_cell: 'Cell',
    string.label_type_fax: 'Fax',
    string.label_type_pager: 'Pager',
    string.label_type_custom: 'Custom',
    string.custom_label: 'Custom label',
    string.cancel: 'Cancel',
    string.quick_actions: 'Quick actions',
    string.call_x: 'Call %s',
    string.text_x: 'Text %s',
    string.email_x: 'Email %s',
    string.search_list_empty_placeholder_text: 'No search results',
    string.import_file_title: 'Import file',
    string.import_file_question: 'Do you want to import the file\'s content?',
    string.share_prompt_title: 'Share via...',
    string.street_address: 'Street address',
    string.locality: 'Locality',
    string.region: 'Region',
    string.postal_code: 'Postal code',
    string.country: 'Country',
    string.website: 'Website',
    string.first_name: 'First Name',
    string.last_name: 'Last Name',
    string.nickname: 'Nickname',
    string.addresses: 'Addresses',
    string.addresses_with_type_x: 'Address (%s)',
    string.organization_division: 'Organization Division',
    string.loading: 'Loading...',
    string.importing: 'Importing...',
    string.export_completed: 'Export completed',
    string.exported_contacts_to_file_x: 'Successfully exported contacts to the file:\n%s',
    string.exporting: 'Exporting...',
    string.change_image: 'Change image',
    string.select_image: 'Select image',
    string.from_gallery: 'From gallery',
    string.from_camera: 'From camera',
    string.delete_image: 'Delete image',
  };

  static _getObjString(final Object _obj) {
    if (_obj == null) {
      return '';
    }
    return _obj.toString();
  }

  static _getStringWithReplacement(
      final String _sourceStr, final int _strIndex, final int _replacedLength, final Object _replacementObj) {
    return _sourceStr.substring(0, _strIndex) +
        _getObjString(_replacementObj) +
        _sourceStr.substring(_strIndex + _replacedLength, _sourceStr.length);
  }

  static getString(final String _stringKey, [final Object _param1, final Object _param2, final Object _param3]) {
    String resString = I18n.currentTranslation[_stringKey];
    if (resString == null) {
      return _stringKey;
    }
    int foundIndex = resString.indexOf('%s');
    if (foundIndex > -1) {
      resString = _getStringWithReplacement(resString, foundIndex, 2, _param1);
    }
    foundIndex = resString.indexOf('%1\$d');
    if (foundIndex == -1) {
      foundIndex = resString.indexOf('%1\$s');
    }
    if (foundIndex > -1) {
      resString = _getStringWithReplacement(resString, foundIndex, 4, _param1);
    }
    foundIndex = resString.indexOf('%2\$d');
    if (foundIndex == -1) {
      foundIndex = resString.indexOf('%2\$s');
    }
    if (foundIndex > -1) {
      resString = _getStringWithReplacement(resString, foundIndex, 4, _param2);
    }
    foundIndex = resString.indexOf('%3\$d');
    if (foundIndex == -1) {
      foundIndex = resString.indexOf('%3\$s');
    }
    if (foundIndex > -1) {
      resString = _getStringWithReplacement(resString, foundIndex, 4, _param3);
    }
    return resString;
  }
}
