$baseDir = "c:\Users\Reena\project_apple\apple-leaf-disease-platform"

# Directories
$dirs = @(
    "$baseDir\backend\models",
    "$baseDir\website\static\css",
    "$baseDir\website\static\js",
    "$baseDir\website\static\images\diseases",
    "$baseDir\website\static\images\icons",
    "$baseDir\website\static\images\background",
    "$baseDir\website\static\uploads",
    "$baseDir\website\templates",
    "$baseDir\mobile_app\android",
    "$baseDir\mobile_app\ios",
    "$baseDir\mobile_app\lib\screens",
    "$baseDir\mobile_app\lib\widgets",
    "$baseDir\mobile_app\lib\models",
    "$baseDir\mobile_app\lib\services",
    "$baseDir\mobile_app\lib\utils",
    "$baseDir\mobile_app\lib\providers",
    "$baseDir\mobile_app\lib\translations",
    "$baseDir\mobile_app\assets\images\diseases",
    "$baseDir\mobile_app\assets\images\icons",
    "$baseDir\mobile_app\assets\fonts",
    "$baseDir\mobile_app\assets\data",
    "$baseDir\docs\project_report\chapters",
    "$baseDir\docs\project_report\images",
    "$baseDir\docs\user_manual",
    "$baseDir\docker"
)

foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$files = @(
    "$baseDir\backend\main.py",
    "$baseDir\backend\model_inference.py",
    "$baseDir\backend\preprocessing.py",
    "$baseDir\backend\disease_database.py",
    "$baseDir\backend\config.py",
    "$baseDir\backend\requirements.txt",
    "$baseDir\backend\models\best.onnx",

    "$baseDir\website\app.py",
    "$baseDir\website\requirements.txt",
    "$baseDir\website\run.py",
    "$baseDir\website\config.py",
    "$baseDir\website\static\css\style.css",
    "$baseDir\website\static\css\responsive.css",
    "$baseDir\website\static\css\animations.css",
    "$baseDir\website\static\js\main.js",
    "$baseDir\website\static\js\camera.js",
    "$baseDir\website\static\js\api.js",
    "$baseDir\website\templates\base.html",
    "$baseDir\website\templates\index.html",
    "$baseDir\website\templates\detect.html",
    "$baseDir\website\templates\results.html",
    "$baseDir\website\templates\about.html",
    "$baseDir\website\templates\contact.html",
    "$baseDir\website\templates\404.html",

    "$baseDir\mobile_app\lib\main.dart",
    "$baseDir\mobile_app\lib\screens\splash_screen.dart",
    "$baseDir\mobile_app\lib\screens\home_screen.dart",
    "$baseDir\mobile_app\lib\screens\camera_screen.dart",
    "$baseDir\mobile_app\lib\screens\gallery_screen.dart",
    "$baseDir\mobile_app\lib\screens\results_screen.dart",
    "$baseDir\mobile_app\lib\screens\disease_info_screen.dart",
    "$baseDir\mobile_app\lib\screens\history_screen.dart",
    "$baseDir\mobile_app\lib\screens\settings_screen.dart",
    "$baseDir\mobile_app\lib\widgets\disease_card.dart",
    "$baseDir\mobile_app\lib\widgets\loading_indicator.dart",
    "$baseDir\mobile_app\lib\widgets\image_picker_button.dart",
    "$baseDir\mobile_app\lib\widgets\result_tile.dart",
    "$baseDir\mobile_app\lib\widgets\custom_appbar.dart",
    "$baseDir\mobile_app\lib\models\disease_model.dart",
    "$baseDir\mobile_app\lib\models\detection_result.dart",
    "$baseDir\mobile_app\lib\models\user_model.dart",
    "$baseDir\mobile_app\lib\models\treatment_model.dart",
    "$baseDir\mobile_app\lib\services\api_service.dart",
    "$baseDir\mobile_app\lib\services\image_picker_service.dart",
    "$baseDir\mobile_app\lib\services\local_storage.dart",
    "$baseDir\mobile_app\lib\services\notification_service.dart",
    "$baseDir\mobile_app\lib\utils\constants.dart",
    "$baseDir\mobile_app\lib\utils\theme.dart",
    "$baseDir\mobile_app\lib\utils\validators.dart",
    "$baseDir\mobile_app\lib\utils\image_processor.dart",
    "$baseDir\mobile_app\lib\providers\detection_provider.dart",
    "$baseDir\mobile_app\lib\providers\history_provider.dart",
    "$baseDir\mobile_app\lib\providers\theme_provider.dart",
    "$baseDir\mobile_app\lib\translations\en.dart",
    "$baseDir\mobile_app\lib\translations\hi.dart",
    "$baseDir\mobile_app\assets\images\logo.png",
    "$baseDir\mobile_app\assets\images\splash_logo.png",
    "$baseDir\mobile_app\assets\data\disease_database.json",
    "$baseDir\mobile_app\pubspec.yaml",
    "$baseDir\mobile_app\pubspec.lock",
    "$baseDir\mobile_app\README.md",

    "$baseDir\docs\project_report\report.pdf",
    "$baseDir\docs\user_manual\website_manual.pdf",
    "$baseDir\docs\user_manual\app_manual.pdf",
    "$baseDir\docs\api_documentation.md",
    "$baseDir\docs\presentation.pptx",
    "$baseDir\docs\demo_video.mp4",

    "$baseDir\docker\Dockerfile.backend",
    "$baseDir\docker\Dockerfile.website",
    "$baseDir\docker\docker-compose.yml",

    "$baseDir\.gitignore",
    "$baseDir\README.md",
    "$baseDir\requirements.txt"
)

foreach ($file in $files) {
    New-Item -ItemType File -Force -Path $file | Out-Null
}

Write-Host "Directory structure created successfully."
