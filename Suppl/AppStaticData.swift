class AppStaticData {
    
    public static let baseSearchQueriesList = [
        "Pink Floyd",
        "Led Zeppelin",
        "Rolling Stones",
        "Queen",
        "Nirvana",
        "The Beatles",
        "Metallica",
        "Bon Jovi",
        "AC/DC",
        "Red Hot Chili Peppers"
    ]
    
    public static let themesList = [
        "Purple",
        "Blue",
        "Black"
    ]
    
    public static let APIErrorsList = [
        0 : "system_config_not_loaded",
        1 : "system_database_error",
        2 : "system_not_found_component",
        3 : "system_method_not_exist",
        4 : "system_component_consist_error",
        5 : "system_spam_control",
        15 : "account_database_error",
        16 : "account_user_not_found",
        17 : "account_wrong_access_key",
        18 : "account_ip_clamed",
        19 : "account_wrong_access_key",
        20 : "account_email_clamed",
        21 : "account_email_not_valid",
        22 : "account_email_not_connected_to_account",
        23 : "account_send_mail_error",
        24 : "account_reset_key_not_valid",
        35 : "music_unregistered_error",
        36 : "music_track_server_error",
        37 : "music_track_not_found",
        38 : "music_tracklist_database_error",
        39 : "music_tracklist_not_found",
        40 : "music_tracklist_empty",
        41 : "music_tracklist_already_added",
        42 : "music_tracklist_out_of_range"
    ]
    
    public static let ruAPIErrorsList = [
        1 : "Ошибка сервера",
        5 : "Спам контроль",
        15 : "Ошибка сервера",
        16 : "Пользователь не найден",
        17 : "Неверный идентификатор",
        18 : "Повторная регистрация невозможна",
        19 : "Неверный идентификатор",
        20 : "EMail занят",
        21 : "EMail неверного формата",
    ]
}
