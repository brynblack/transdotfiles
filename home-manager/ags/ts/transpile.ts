export function convertGtkToScss(gtkCss: string) {
  const colorRegex = /@define-color (\w+) (\S+|rgba.+);\n/g;
  let scss = '';
  let match: RegExpExecArray | null;
  
  while ((match = colorRegex.exec(gtkCss)) !== null) {
    const [_, name, tmp] = match;
    const value = tmp.replace(/@(.+)/g, (_, p1) => `$${p1}`);
    scss += `$${name}: ${value};\n`;
  }

  const cssBody = gtkCss.replace(colorRegex, '');
  const scssBody = cssBody.replace(/@([\w_]+_color)/g, (_, p1) => `$${p1}`);

  return scss + scssBody;
}
