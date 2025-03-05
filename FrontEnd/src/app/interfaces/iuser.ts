export interface IUser {
    id: number | null;
    first_name: string;
    last_name: string;
    email: string;
    birthday: Date;
    password: string;
    c_password: string;
    username: string;
    rank: string;
    logo: string;
    bio: string;
    certified: boolean;
}