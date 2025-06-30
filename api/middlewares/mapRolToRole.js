// Corrige la propiedad rol a role en req.user para que isAdmin funcione
const mapRolToRole = (req, res, next) => {
  if (req.user && req.user.rol && !req.user.role) {
    req.user.role = req.user.rol;
  }
  next();
};

module.exports = mapRolToRole;

