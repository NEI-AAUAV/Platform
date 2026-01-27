/**
 * Family Components - Reusable components for family tree management
 * 
 * Exports:
 * - PatraoPicker: Component for selecting a patrão (parent/mentor)
 * - ChildrenList: Component for displaying a user's children (pedaços)
 * - RoleDisplay: Component for displaying and managing user roles/insignias
 * - UserListDisplay: Component for displaying lists of users with avatars and year dots
 * - Modals: All family-related modals (CourseManagerModal, ProfileViewModal, RoleManagerModal, RolePickerModal, IconPicker)
 */

export { default as PatraoPicker } from './PatraoPicker';
export { default as ChildrenList } from './ChildrenList';
export { default as RoleDisplay } from './RoleDisplay';
export { default as UserListDisplay } from './UserListDisplay';

// Export modals
export * from './Modals';

