import { IUser } from "../interfaces/iuser";

export class User implements IUser {
    constructor(
      public first_name: string,
      public last_name: string,
      public email: string,
      public birthday: string,
      public password: string,
      public c_password: string,
      public username: string,
      public rank: string,
      public logo: string,
      public bio: string,
      public certified: boolean,
      public id?: number,
    ) {}
}
