const fs = require('fs');
const path = require('path');

const dir = 'c:/Users/tuan/Downloads/LuxuryPC (2)/LuxuryPC/src/main/resources';

function walkSync(currentDirPath, callback) {
    fs.readdirSync(currentDirPath).forEach(function (name) {
        var filePath = path.join(currentDirPath, name);
        var stat = fs.statSync(filePath);
        if (stat.isFile()) {
            callback(filePath, stat);
        } else if (stat.isDirectory()) {
            walkSync(filePath, callback);
        }
    });
}

walkSync(dir, function(filePath) {
    if (filePath.endsWith('.html') || filePath.endsWith('.css')) {
        let content = fs.readFileSync(filePath, 'utf8');
        let newContent = content;
        
        newContent = newContent.replace(/family=Cormorant\+Garamond[^&]*&family=Montserrat[^&]*&/g, 'family=Outfit:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&');
        newContent = newContent.replace(/--serif:\s*['"]Cormorant Garamond['"][^;]*;/g, "--serif: 'Outfit', sans-serif;");
        newContent = newContent.replace(/--sans:\s*['"]Montserrat['"][^;]*;/g, "--sans: 'Inter', sans-serif;");
        newContent = newContent.replace(/--font-serif:\s*['"]Inter['"][^;]*;/g, "--font-serif: 'Outfit', sans-serif;");
        
        if (content !== newContent) {
            fs.writeFileSync(filePath, newContent, 'utf8');
            console.log('Updated', filePath);
        }
    }
});
