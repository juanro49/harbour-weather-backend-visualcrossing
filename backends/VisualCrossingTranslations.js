.pragma library

// Archivo generado automáticamente. No editar manualmente.
var vcCatalog = {
    "es": {
        "title": "Visual Crossing",
        "instructions": "Para obtener tu API key:<ol><li>Regístrate en <b><a href='%1'>Visual Crossing</a></b>, introduce tu email y verifícalo con el código que recibas.</li><li>Copia tu clave desde la sección <b>Account</b>.</li><li>Introdúcela arriba.</li></ol>",
        "attribution": "Datos meteorológicos de %1Visual Crossing%2.",
        "short-attribution": "Datos de Visual Crossing"
    },
    "en": {
        "title": "Visual Crossing",
        "instructions": "To obtain your API key:<ol><li>Register an account.</li><li>Go to <b><a href='%1'>Visual Crossing</a></b>, enter your email and verify it with the code you receive.</li><li>Copy your key from the <b>Account</b> section.</li><li>Enter it above.</li></ol>",
        "attribution": "Weather data from %1Visual Crossing%2.",
        "short-attribution": "Weather data from Visual Crossing"
    }
};

function translate(id, lang) {
    var l = (lang || "en").toLowerCase().substring(0, 2);
    if (!vcCatalog[l]) l = "en";
    var translation = vcCatalog[l][id] || vcCatalog["en"][id] || id;
    return translation;
}
