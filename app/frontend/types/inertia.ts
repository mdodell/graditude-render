import { JSX, ReactNode } from 'react';

export type PageProps = {
  //   user: {
  //     id: number;
  //     name: string;
  //     // Add other shared props if needed
  //   };
  auth: {
    session: {
      id: string;
    };
  };
};

export type AppPage<P = {}> = React.FC<P & PageProps> & {
  layout?: (page: ReactNode) => JSX.Element;
};
