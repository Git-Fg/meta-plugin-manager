// BEFORE: Deep nesting obscures control flow
function canAccessResource(
  user: User | null,
  resource: Resource | null,
  action: string,
): boolean {
  if (user) {
    if (user.isActive) {
      if (user.hasPermission(action)) {
        if (resource) {
          if (resource.isPublic || resource.ownerId === user.id) {
            return true;
          }
        }
      }
    }
  }
  return false;
}

// AFTER: Early returns make intent clear
function canAccessResource(
  user: User | null,
  resource: Resource | null,
  action: string,
): boolean {
  if (!user || !user.isActive) return false;
  if (!user.hasPermission(action)) return false;
  if (!resource) return false;
  if (resource.isPublic) return true;
  if (resource.ownerId === user.id) return true;

  return false;
}

// FURTHER REFACTOR: Extract guard conditions
function canAccessResource(
  user: User | null,
  resource: Resource | null,
  action: string,
): boolean {
  if (!isUserEligible(user, action)) return false;
  if (!isResourceAccessible(user, resource)) return false;

  return true;
}

function isUserEligible(user: User | null, action: string): boolean {
  if (!user) return false;
  if (!user.isActive) return false;
  return user.hasPermission(action);
}

function isResourceAccessible(user: User, resource: Resource | null): boolean {
  if (!resource) return false;
  if (resource.isPublic) return true;
  return resource.ownerId === user.id;
}
